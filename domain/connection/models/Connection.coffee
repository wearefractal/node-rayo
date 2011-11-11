_ = require 'slice'

xmppClient   = _.load 'xmpp.models.XMPPClient'
messageQueue = _.load 'message.models.MessageQueue'
parseHost    = _.load 'connection.services.parseHost'
send         = _.load 'connection.services.send'


class Connection

  constructor: ({@host, @port, @jabberId, @jabberPass, @verbose}) ->

    {@host, @port} = parseHost @host, @port
    @verbose ?= false

    @xmppClient = new xmppClient @ # inject self
    @messageQueue = new messageQueue @

  connect: -> @xmppClient.connect()
  disconnect: -> @xmppClient.disconnect()

  send: (command, callback) -> send command, callback, @


module.exports = Connection

