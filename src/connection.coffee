xmpp = require 'node-xmpp'
static = require './static'
EventEmitter = require('events').EventEmitter

class Connection extends EventEmitter
  constructor: ({@host, @jabberId, @jabberPass}) ->
    @host ?= static.default.host
    if @host.contains ':' then [@host, @port] = @host.split ':' # Split out the port if they put it in the server. Idiocy fallback
    @port ?= static.defaultPort

  connect: ->
    @queue.clear()
    @conn = new xmpp.Client
      jid: @jabberId
      password: @jabberPass
      host: @server
      port: @port

    @conn.on 'online', ->
      @conn.on 'stanza', @handleStanza
      @emit 'connected'
      @conn.send new xmpp.Element('presence').c('show').t('chat').up().c('status').t('I am online!') # Change status to online. TODO: Customize

    @conn.on 'authFail', (err) -> @emit 'error', err
    @conn.on 'error', (err) -> @emit 'error', err

  disconnect: -> @conn.end()

  send: (command, cb) ->
    # TODO: Append @message running getElement. @message = jabberids and shit
    @conn.send command.getElement()
    @queue[command.getId()] = (err, res) ->
      if res.attrs.id
        delete @queue[res.attrs.id]
        cb err, res

  ###
    Handlers for incoming messages/events
  ###
  handleStanza: (stanza) ->
    console.log stanza
    throw new Error "Message from unknown domain #{ stanza.from.domain }" unless stanza.from.domain is @server
    if stanza.attrs.type is 'error' then return handleError stanza

    switch stanza.name
      when 'presence' then handlePresence stanza
      when 'iq' then handleIq stanza
      else throw new Error "Unknown Stanza type. Stanza: #{ stanza }"

  handleIq: (iq) ->
    switch stanza.attrs.type
      when 'error' then handleError iq
      when 'success'
        cb = @getListener iq
        cb null, stanza.getChild()
      else console.log 'Unknown Iq - ' + iq

  handlePresence: (presence) ->
    throw new Error "Stanza is not Rayo protocol. Stanza: #{ presence }" unless @isRayo presence
    if stanza.attrs.type is 'error' then return handleError presence
    cb = @getListener presence
    type = presence.getChild()

  handleError: (stanza) ->
    cb = @getListener stanza
    cb new Error stanza.getChild().value ? "Generic Stanza Error. Stanza: #{ stanza }"

  ###
    Utilities
  ###
  isRayo: (stanza) -> return stanza.getNS() is static.xmlns

  getListener: (stanza) ->
    throw new Error "Missing stanza.attrs.id. Stanza: #{ stanza }" unless stanza.attrs.id
    callback = @queue[stanza.attrs.id]
    if callback?
      return callback
    else
      return ->

