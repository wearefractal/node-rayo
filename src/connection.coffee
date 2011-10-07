xmpp = require 'simple-xmpp'
EventEmitter = require('events').EventEmitter

class Connection extends EventEmitter
  constructor: (@server, @jabberId, @jabberPass) ->
    if @server.contains ':'
      [@server, @port] = @server.split ':'
    else
      @port = 5222

  connect: ->
    xmpp.connect
      jid: @jabberId
      password: @jabberPass
      host: @server
      port: @port

    xmpp.on 'online', -> @emit 'connected', xmpp.conn
    xmpp.on 'error', (err) -> @emit 'failure', err

