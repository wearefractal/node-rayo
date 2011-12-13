#>> Setup

  _ = require 'slice'
  should = require 'should'
  handleRayoMessage = _.load 'connection.handleRayoMessage'
  EventEmitter = _.load('events').EventEmitter

#>> Given an EventEmitter, a callbackRouter and a message

  ee        = new EventEmitter() 
  cbRouter  =
    call: (id) -> # nada
  msg       = "foo"

  ee.on 'some.command', (command) ->
    console.log 'some command'
#  >> c

#>> When I call handleRayoMessage

  cbRouter = handleRayoMessage ee, cbRouter, msg

  console.log cbRouter
#>> 
