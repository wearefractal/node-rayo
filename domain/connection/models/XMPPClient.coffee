_ = require 'slice'
xmpp = _.load 'node-xmpp'
config = _.load 'connection.config'

class XMPPClient extends xmpp
  constructor: ({@host, @port, @jabberId, @jabberPass, @verbose}) ->

    @host ?= config.default.host

    # Split out the port if they put it in the server #idiocy
    if @host.indexOf ':' > 0 then [@host, @port] = @host.split ':'

    @port ?= config.default.port

    new xmpp.Client
      jid: @jabberId
      password: @jabberPass
      host: @server
      port: @port

