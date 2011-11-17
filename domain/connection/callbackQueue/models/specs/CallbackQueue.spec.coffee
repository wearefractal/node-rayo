>> Setup

  _ = require 'slice'
  CallbackQueue = _.load 'xmpp.callbackQueue.models.CallbackQueue'

>> Given a callback queue and a @counter

  callbackQueue = new CallbackQueue
  @counter = 0

>> When I push a couple callbacks onto the queue

  callbackQueue.push "five", => @counter += 5
  callbackQueue.push "three", => @counter += 3

>> Then the callbacks should be in the queue

  callbackQueue.queue.should.have.keys "five", "three"


>> When we call id "five"

  callbackQueue.call "five"

>> Then @counter should equal 5

  @counter.should.equal 5


>> When we call id "three"

  callbackQueue.call "three"

>> Then @counter should be 8 (5 + 3)

  @counter.should.equal 8

