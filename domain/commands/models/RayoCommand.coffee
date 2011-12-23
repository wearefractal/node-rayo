{EventEmitter} = require 'events'
createCommand = require '../services/createCommand'
generateId = require '../services/generateId'

class RayoCommand extends EventEmitter
  constructor: (@messageName, @message) ->
    @message.msgid ?= generateId()
    @[prop] = val for prop, val of @message # Extend message
    
  getElement: (xmpp) -> # This gets called on send to form the actual command
    xmpp.once @msgid, (name, cmd) => @emit name, cmd if callid? # Single response event
    xmpp.on @callid, (name, cmd) => @emit name, cmd if callid? # All relevant call events
    return createCommand xmpp, @messageName, @message

module.exports = RayoCommand
