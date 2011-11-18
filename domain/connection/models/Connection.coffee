_ = require 'slice'
#EventEmitter  = _.load('events').EventEmitter
JabClient  = _.load 'xmpp.models.JabClient'
send       = _.load 'connection.services.send'

console.log XMPPClient

class Connection extends JabClient

  constructor: ({@host, @port, @jabberId, @jabberPass, @verbose, @status}) ->
     @callbackQueue = new CallbackQueue()

#    super arguments

#    @xmppClient = createXmppClient @
#    @on '*', (command) -> @xmppClient.handleMessage command.getRaw()

#  connect: -> @xmppClient.connect()
#  disconnect: -> @xmppClient.disconnect()

  send: (command, callback) -> send @xmppClient, command, callback


module.exports = Connection

###
      host: @host
      port: @port
      jabberId: @jabberId
      jabberPass: @jabberPass
      verbose: @verbose
      status: @status

