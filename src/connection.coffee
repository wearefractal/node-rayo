xmpp = require 'node-xmpp'
static = require './static'
rayo = require './rayo'
Message = require './message'

EventEmitter = require('events').EventEmitter

class Connection extends EventEmitter
  constructor: ({@host, @port, @jabberId, @jabberPass, @verbose}) ->
    @host ?= static.default.host
    if @host.indexOf ':' > 0 then [@host, @port] = @host.split ':' # Split out the port if they put it in the server. Idiocy fallback
    @port ?= static.default.port
    @verbose ?= false
  
  connect: ->
    @callbacks = {}
    @conn = new xmpp.Client
      jid: @jabberId
      password: @jabberPass
      host: @server
      port: @port

    @conn.on 'online', =>
      @connected = true
      @conn.on 'stanza', (stanza) => @handleStanza stanza
      @emit 'connected'
      @conn.send new xmpp.Element('presence').c('show').t('chat').up().c('status').t('I am online!') # Change status to online. TODO: Customize
      
    @conn.on 'offline', => 
      @connected = false
      @emit 'disconnected'
      
    @conn.on 'authFail', (err) => @emit 'error', err # TODO: Standardize this error

    @conn.on 'error', (err) => @emit 'error', err
    
    # Match incoming messages with a callback
    matchQueue = (cmd) =>
      id = cmd.getId()
      if id?
        cb = @callbacks[id]
        cb? null, cmd
        delete cb
            
    @on 'message', matchQueue
      
  disconnect: -> @conn.end()

  send: (command, cb) ->
    el = command.getElement @host, @conn.jid
    if @verbose then console.log 'Sending outbound message: ' + el.toString()
    if cb? and typeof cb is 'function' 
      @callbacks[command.getId()] = cb
    @conn.send el
    
  ###
    Handlers for incoming messages/events
  ###
  handleStanza: (stanza) ->
    @emit 'stanza', stanza # Emits 'stanza' with raw stanza
    if @verbose then console.log 'Receiving inbound message: ' + stanza
    # throw new Error "Message from unknown domain #{ stanza.attrs.from.domain }" unless stanza.attrs.from.domain is @conn.server
    if stanza.attrs.type is 'error' then return @handleError stanza
    @emit stanza.name, stanza # Emits 'iq' or 'presence' with raw stanza
    message = @getMessage stanza
    @emit message.childName, message # Emits command name with formatted stanza
    @emit 'message', message # Emits 'message' with formatted stanza
      
  handleError: (stanza) ->
    cb = @callbacks[stanza.attrs.id]
    if cb? and typeof cb is 'function'
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

