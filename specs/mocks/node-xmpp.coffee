xmpp = require 'node-xmpp'
EventEmitter = require('events').EventEmitter

xmpp.Client =

  class xmppClient extends EventEmitter
    constructor: ({@jid, @password, @host, @port}) ->
    send: (@sentElement) ->

module.exports = xmpp

