xmpp = require 'node-xmpp'
static = require './static'
rayo = require './rayo'
Presence = require './presence'
Iq = require './iq'

EventEmitter = require('events').EventEmitter

class Connection extends EventEmitter
  constructor: ({@host, @port, @jabberId, @jabberPass}) ->
    @host ?= static.default.host
    if @host.contains ':' then [@host, @port] = @host.split ':' # Split out the port if they put it in the server. Idiocy fallback
    @port ?= static.default.port

  connect: ->
    @queue = []
    @conn = new xmpp.Client
      jid: @jabberId
      password: @jabberPass
      host: @server
      port: @port

    @conn.on 'online', =>
      @conn.on 'stanza', (stanza) => @handleStanza stanza
      @emit 'connected'
      @conn.send new xmpp.Element('presence').c('ping')
      #@conn.send new xmpp.Element('presence').c('show').t('chat').up().c('status').t('I am online!') # Change status to online. TODO: Customize

    @conn.on 'authFail', (err) => @emit 'error', err # TODO: Standardize this error

    @conn.on 'error', (err) => @emit 'error', err

  disconnect: -> @conn.end()

  send: (command, cb) ->
    el = command.getElement @host, @conn.jid
    console.log 'Sending outbound message: ' + el.toString()
    @conn.send el
    if Object.isFunction cb
      @queue[command.getId()] = (err, res) =>
        delete @queue[res.attrs.id] if res?.attrs?.id
        cb err, res

  ###
    Handlers for incoming messages/events
  ###
  handleStanza: (stanza) ->
    console.log 'Receiving inbound message: ' + stanza
    # throw new Error "Message from unknown domain #{ stanza.from.domain }" unless stanza.from.domain is @conn.server
    if stanza.attrs.type is 'error' then return @handleError stanza
    switch stanza.name
      when 'presence' then @handlePresence stanza
      when 'iq' then @handleIq stanza
      else console.log "Unknown Stanza type. Stanza: #{ stanza }"

  handleIq: (iq) ->
    @emit 'iq', iq
    switch iq.attrs.type
      when 'error' then @handleError iq
      when 'result'
        cb = @getListener iq
        child = iq.children[0]
        if child
          head = {}
          childs = {}
          head[x.attrs.name] = x.attrs.value for x in child.children when x.name is 'header'
          childs[x.name] = x.attrs for x in child.children when x.name != 'header'
          icky = new Iq type: child.type or iq.type, message: iq.attrs, attributes: child.attrs, headers: head, children: childs
        else
          icky = new Iq type: iq.type, message: iq.attrs
        @emit icky.type, icky # Emit event for incoming command
        cb null, icky
      else console.log 'Unknown Iq - ' + iq

  handlePresence: (presence) ->
    @emit 'presence', presence
    child = presence.children[0]
    if @isRayo child
      cb = @getListener presence
      head = {}
      childs = {}
      head[x.attrs.name] = x.attrs.value for x in child.children when x.name is 'header'
      childs[x.name] = x.attrs for x in child.children when x.name != 'header'
      command = new Presence type: child.name, message: presence.attrs, attributes: child.attrs, headers: head, children: childs
      @emit child.name, command # Emit event for incoming command 
      cb null, command
      
  handleError: (stanza) ->
    cb = @getListener stanza
    cb new Error(stanza.children[0]?.children[0]?.name or "Stanza Error! Stanza: #{ stanza }") # TODO: Standardize

  ###
    Utilities
  ###
  isRayo: (stanza) -> return stanza?.getNS() is static.xmlns

  getListener: (stanza) ->
    # Incoming calls have no id, commented out for now
    # throw new Error "Missing stanza.attrs.id. Stanza: #{ stanza }" unless stanza.attrs.id
    callback = @queue[stanza.attrs.id]
    if callback?
      return callback
    else
      return ->

module.exports = Connection

