_ = require 'slice'
config = _.load 'connection.config'
#EventEmitter = _.load('events').EventEmitter
xmppClient = _.load 'connection.xmpp.models.XMPPClient'
send = (args...) -> #_.load 'connection.services.send'

class Connection #extends EventEmitter

  constructor: ({@host, @port, @jabberId, @jabberPass, @verbose}) ->

    @host ?= config.default.host
    # Split out the port if they put it in the server
    if @host.indexOf ':' > 0 then [@host, @port] = @host.split ':'
    @port ?= config.default.port
    @verbose ?= false
    @xmppClient = new xmppClient @ # inject self to xmppClient

  connect: -> @xmppClient.connect()
  disconnect: -> @xmppClient.disconnect()

  send: (command, callback) -> send @xmppClient, command, callback


module.exports = Connection

## TEST

should = require 'should'

#>> When I try to create a Connection

conn = new Connection
  host: 'telefonica115.orl.voxeo.net'
  jabberId: 'wearefractal@jabber.org'
  jabberPass: 'ill4jabber'
  verbose: true

#>> Then it should be created ok

conn.should.be.ok

#>> When I try to create a Connection with port in the host

conn = new Connection
  host: 'telefonica115.orl.voxeo.net:8080'
  jabberId: 'wearefractal@jabber.org'
  jabberPass: 'ill4jabber'
  verbose: true

#>> Then it should split it out ok

conn.port.should.equal '8080'

