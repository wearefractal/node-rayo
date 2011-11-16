>> Setup

  _ = require 'slice'
  CallbackQueue = _.load 'xmpp.callbackQueue.models.CallbackQueue'

>> Given a callback queue and sample message

  callbackQueue = new CallbackQueue

>> And I push some messages onto the queue
  @counter = 0

  callbackQueue.push "blah", => @counter += 5
  callbackQueue.push "glah", => @counter += 3

  console.log callbackQueue.queue

>> Then there should be 2 messages in the queue

  callbackQueue.queue.should.have.keys "blah", "glah"

>> When I activate a callback on a message

  callbackQueue.call "blah"

>> Then the callback should fire off and have an effect on the system

  @counter.should.equal 5

>> When I activate a callback on a message

  callbackQueue.call "glah"

>> Then the callback should fire off and have an effect on the system

  @counter.should.equal 8

