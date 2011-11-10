_ = require 'slice'
xmpp = _.load 'node-xmpp'
config = _.load 'connection.config'

handleStanza = _.load 'xmpp.services.handleStanza'
setStatus = _.load 'xmpp.services.setStatus'


class XMPPClient
 constructor: (@connection) ->

    @connection.status ?= "I am online"

  connect: ->

    # connects on creation
    @xmppClient = new xmpp.Client
      jid: @connection.jabberId
      password: @connection.jabberPass
      host: @connection.server
      port: @connection.port

    # online
    @xmppClient.on 'online', =>
      console.log 'online'
      @connected = true
      @xmppClient.on 'stanza', (stanza) => handleStanza stanza, @connection
      @emit 'connected'
      setStatus @, @connection.status

    # offline
    @xmppClient.on 'offline', =>
      @connected = false
      @emit 'disconnected'

    # error
    @xmppClient.on 'authFail', (err) => @emit 'error', err
    @xmppClient.on 'error', (err) => @emit 'error', err

  disconnect: -> @xmppClient.end()

  send: (element) -> @xmppClient.send element


module.exports = XMPPClient

