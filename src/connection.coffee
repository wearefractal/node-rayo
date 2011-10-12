xmpp = require 'node-xmpp'
static = require './static'
rayo = require './rayo'
Presence = require './presence'
Iq = require './iq'

EventEmitter = require('events').EventEmitter

class Connection extends EventEmitter
  constructor: ({@host, @jabberId, @jabberPass}) ->
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
      @conn.send new xmpp.Element('presence').c('show').t('chat').up().c('status').t('I am online!') # Change status to online. TODO: Customize

    @conn.on 'authFail', (err) => @emit 'error', err # TODO: Standardize this error

    @conn.on 'error', (err) => @emit 'error', err

  disconnect: -> @conn.end()

  send: (command, cb) ->
    # TODO: Append @message running getElement. @message = jabberids and shit
    el = command.getElement()
    console.log 'Sending outbound message: ' + el.toString()
    @conn.send el
    if Object.isFunction cb
      @queue[command.getId()] = (err, res) =>
        if err
          cb err
        else if res.attrs.id
          delete @queue[res.attrs.id]
          cb err, res

  ###
    Handlers for incoming messages/events
  ###
  handleStanza: (stanza) ->
    console.log 'Receiving inbound message: ' + stanza
    # throw new Error "Message from unknown domain #{ stanza.from.domain }" unless stanza.from.domain is @conn.server
    if stanza.attrs.type is 'error' then return @handleError stanza
    # TODO: Fire event for stanza ID
    switch stanza.name
      when 'presence' then @handlePresence stanza
      when 'iq' then @handleIq stanza
      else throw new Error "Unknown Stanza type. Stanza: #{ stanza }"

  handleIq: (iq) ->
    # console.log 'New Iq stanza: ' + iq.toString()
    switch iq.attrs.type
      when 'error' then @handleError iq
      when 'success'
        cb = @getListener iq
        cb null, stanza.getChild()
      else console.log 'Unknown Iq - ' + iq

  handlePresence: (presence) ->
    if presence.attrs.type is 'error' then return @handleError presence
    cb = @getListener presence
    child = presence.children[0]
    
    if @isRayo child
      console.log "Received new #{ child.name } presence"
      head = {}
      head[x.attrs.name] = x.attrs.value for x in child.children when x.name is 'header'
      command = new Presence type: child.name, message: presence.attrs, attributes: child.attrs, headers: head
        
      @emit child.name, command # Emit event for incoming command
      @emit 'presence', command
    else
      @emit 'stanza', presence
      
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

