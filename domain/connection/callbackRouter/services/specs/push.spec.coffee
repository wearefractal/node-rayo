>> Setup

  _ = require 'slice'
  push = _.load 'xmpp.callbackQueue.services.push'

>> Given a queue (an empty array)

  queue = []


>> When I push some messages onto the queue

  push queue, 'id1', ->
  push queue, 'id2', ->


>> Then there should be 2 messages in the queue

  queue.should.have.keys 'id1' , 'id2'


>> When I push A non callback onto the queue

  push queue, -1, 0

