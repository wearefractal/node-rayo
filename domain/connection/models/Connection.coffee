_ = require 'slice'
config = _.load 'connection.config'
xmppClient = _.load 'xmpp.models.XMPPClient'
send = _.load 'connection.services.send'

# checking mocking functionality
# console.log send.toString()

class Connection

  constructor: ({@host, @port, @jabberId, @jabberPass, @verbose}) ->

    @host ?= config.default.host
    # Split out the port if they put it in the server
    if @host.indexOf ':' > 0 then [@host, @port] = @host.split ':'

    @port ?= config.default.port
    @verbose ?= false
    @xmppClient = new xmppClient @ # inject self to xmppClient

  connect: -> @xmppClient.connect()
  disconnect: -> @xmppClient.disconnect()

  send: (command, callback) -> send command, callback, @


module.exports = Connection

