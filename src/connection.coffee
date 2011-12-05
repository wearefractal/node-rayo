path = require 'path'
static = require './static'
rayo = require './rayo'
util = require 'util'
Message = require './message'
EventEmitter = require('events').EventEmitter

class Connection extends EventEmitter
  constructor: ({@xmpp, @host, @port, @jabberId, @jabberPass, @verbose}) ->
    @xmpp ?= require 'node-xmpp'
    @host ?= static.default.host
    if @host.indexOf ':' > 0 then [@host, @port] = @host.split ':' # Split out the port if they put it in the server. Idiocy fallback
    @port ?= static.default.port
    @verbose ?= false
  #
  connect: ->
    @callbacks = {}

    @xmppClient = new @xmpp.Client
      jid: @jabberId
      password: @jabberPass
      host: @server
      port: @port

    @xmppClient.on 'online', =>
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
    @emit 'message', message # Emits 'message' with formatted stanza

  #
  handleError: (stanza) ->
    cb = @callbacks[stanza.attrs.id]
    err = stanza.children[0]
    delete err.parent # Remove clutter from LTX element
    @emit 'error', err
    if cb? and typeof cb is 'function'
      return cb new Error err
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

