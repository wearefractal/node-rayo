_ = require 'slice'
EventEmitter  = _.load('events').EventEmitter
config        = _.load 'connection.config'
handleStanza  = _.load 'xmpp.services.handleStanza'
setStatus     = _.load 'xmpp.services.setStatus'
parseHost     = _.load 'connection.services.parseHost' # move to xmpp
callbackQueue = _.load 'xmpp.callbackQueue.models.CallbackQueue'

class XMPPClient extends EventEmitter

 constructor: ({@host, @port, @jabberId, @jabberPass, @verbose, @status}) ->

    @status ?= "I am online"
    @verbose ?= false
    {@host, @port} = parseHost @host, @port

    @callbackQueue = new callbackQueue()

  connect: ->

    @xmppClient = createAndConnectXmppClient()

    # online
    @xmppClient.on 'online', =>
      console.log 'online'
      @connected = true
      # handle all incoming stanzas
      @xmppClient.on 'stanza', (stanza) => handleStanza @xmppClient, stanza
      @emit 'connected'
      setStatus @xmppClient, @status

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

