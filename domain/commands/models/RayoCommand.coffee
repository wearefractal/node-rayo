{EventEmitter} = require 'events'
createCommand = require '../services/createCommand'
generateId = require '../services/generateId'
#dump = (obj) -> console.log require('util').inspect(obj)

class RayoCommand extends EventEmitter
  constructor: (@messageName, @message) ->
    @message.msgid ?= generateId()
    @[prop] = val for prop, val of @message # Extend message
    
  # This gets called on send to form the actual command
  getElement: (xmpp) -> 

    # Sets off the callback queue
    xmpp.once @msgid, (name, cmd) => @emit name, cmd if callid? 
    # All relevant call events
    xmpp.on @callid, (name, cmd) => @emit name, cmd if callid? 
 
    return createCommand xmpp, @messageName, @message

module.exports = RayoCommand
