_ = require 'slice'
EventEmitter = _.load('events').EventEmitter

class XMPPClient extends EventEmitter
  constructor: (args) ->
    @callbackQueue = []
  connect: ->
  disconnect: ->
  send: (el) ->


module.exports = XMPPClient

