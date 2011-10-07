xmpp = require 'node-xmpp'
EventEmitter = require('events').EventEmitter

class Connection extends EventEmitter
  constructor: (@server, @jabberId, @jabberPass) ->
    @server ?= 'call.rayo.net'
    if @server.contains ':'
      [@server, @port] = @server.split ':'
    else
      @port = 5222

  connect: ->
    @queue = []
    @conn = xmpp.Client
      jid: @jabberId
      password: @jabberPass
      host: @server
      port: @port

    @conn.on 'online', ->
      @conn.on 'stanza', @handleStanza
      @emit 'connected'

    @conn.on 'authFail', (err) -> @emit 'failure', err
    @conn.on 'error', (err) -> @emit 'error', err

  disconnect: -> @conn.end()

  send: (command, cb) ->
    element = command.getElement()
    @conn.send element
    @queue[element.id] = (err, res) ->
      @queue = @queue.remove element.id
      cb err, res

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
    cb new Error stanza.getChild().getText() || "Generic Stanza Error. Stanza: #{ stanza }"

  # Utility stuff
  isRayo: (stanza) -> return stanza.getNS() is 'urn:xmpp:rayo:1'

  getListener: (stanza) ->
    throw new Error "Missing stanza.attrs.id. Stanza: #{ stanza }" unless stanza.attrs.id
    callback = @queue[stanza.attrs.id]
    if callback?
      return callback
    else
      return ->

