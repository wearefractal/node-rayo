_ = require 'slice'
push = _.load 'xmpp.callbackQueue.services.push'
call = _.load 'xmpp.callbackQueue.services.call'

class CallbackQueue
  constructor: ->
    @queue = []

  push: (id, callback) -> push @queue, id, callback

  call: (id, args) -> call @queue, id, args?



module.exports = CallbackQueue

