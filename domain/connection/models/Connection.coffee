_ = require 'slice'
path = _.load 'path'
EventEmitter = _.load('events').EventEmitter
Message = _.load 'message.models.message'
config = _.load 'config'
xmpp = _.load 'connection.models.XMPPClient'

class Connection extends EventEmitter
  constructor: ({@client, @verbose}) ->
    @verbose ?= false
  #
  connect: (xmppClient) ->
    @callbacks = {}

    @xmppClient = xmppClient

    @xmppClient.on 'online', =>
      console.log 'online'
      @connected = true
      @xmppClient.on 'stanza', (stanza) => @handleStanza stanza
      @emit 'connected'
      @xmppClient.send new @xmpp.Element('presence').c('show').t('chat').up().c('status').t('I am online!') # Change status to online. TODO: Customize

    @xmppClient.on 'offline', =>
      @connected = false
      @emit 'disconnected'

    @xmppClient.on 'authFail', (err) => @emit 'error', err # TODO: Standardize this error

    @xmppClient.on 'error', (err) => @emit 'error', err

    # Match incoming messages with a callback
    matchQueue = (cmd) =>
      id = cmd.getId()
      if id?
        cb = @callbacks[id]
        cb? null, cmd
        delete cb

    @on 'message', matchQueue

  #
  disconnect: -> @xmppClient.end()

  #
  send: (command, cb) ->
    el = command.getElement @host, @xmppClient.jid
    if @verbose then console.log 'Sending outbound message: ' + el.toString()
    if cb? and typeof cb is 'function'
      @callbacks[command.getId()] = cb
    @xmppClient.send el

  ###
    Handlers for incoming messages/events
  ###
  handleStanza: (stanza) ->
    @emit 'stanza', stanza # Emits 'stanza' with raw stanza
    if @verbose then console.log 'Receiving inbound message: ' + stanza
    # throw new Error "Message from unknown domain #{ stanza.attrs.from.domain }" unless stanza.attrs.from.domain is @xmppClient.server
    if stanza.attrs.type is 'error' then return @handleError stanza
    @emit stanza.name, stanza # Emits 'iq' or 'presence' with raw stanza
    message = @getMessage stanza
    @emit message.childName, message # Emits command name with formatted stanza
    console.log message
    @emit 'message', message # Emits 'message' with formatted stanza

  #
  handleError: (stanza) ->
    cb = @callbacks[stanza.attrs.id]
    console.log "callback"
    if cb? and typeof cb is 'function'
      console.log "cb is a function"
      if stanza.children
        err = (child for child in stanza.children when child.name is 'error')[0]
        if err
          msg = (child for child in err.children when child.name is 'text')[0].children[0]
          return cb new Error "Type: #{ err.attrs.type }, Message: #{ msg }"
        else if stanza.children and stanza.children[0].children
          return cb new Error stanza.children[0].children[0].name
      else
        return cb new Error "Generic Error! Stanza: #{ stanza }"
    else
      console.log 'UNHANDLED ERROR! - ' + stanza

  ###
    Utilities
  ###
  getMessage: (stanza) ->
    child = stanza.children[0]
    if child
      head = {}
      childs = {}
      head[x.attrs.name] = x.attrs.value for x in child.children when x.name is 'header'
      childs[x.name] = x.attrs for x in child.children when x.name != 'header'
      mess = new Message
        rootName: stanza.name
        rootAttributes: stanza.attrs
        childName: child.name
        childAttributes: child.attrs
        sipHeaders: head
        children: childs
    else
      mess = new Message
        rootName: stanza.name
        rootAttributes: stanza.attrs
        childName: stanza.type
    return mess

module.exports = Connection

