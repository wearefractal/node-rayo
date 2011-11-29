>> Setup

  _ = require 'slice'
  call = _.load 'xmpp.callbackQueue.services.call'

>> Given a queue

  queue = []
  @called = false
  queue["bogus"] = => @called = true

>> When I call from the queue

  call queue, "bogus"

>> Then our callback is fired and removed from the queue

  @called.should.equal true
  queue.should.not.have.keys "bogus"

