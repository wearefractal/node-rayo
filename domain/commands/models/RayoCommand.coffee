{EventEmitter} = require 'events'
createCommand = require '../services/createCommand'
generateId = require '../services/generateId'

class RayoCommand extends EventEmitter
  constructor: (@xmpp, @messageName, @message) ->
    @message.msgid ?= generateId()
    @[prop] = val for prop, val of @message # Extend message
    
  # This gets called on send to form the actual command
  getElement: -> 

    # Sets off the callback queue
    @xmpp.once @msgid, (name, cmd) => @emit name, cmd if callid? 
    @listen(@callid) if @callid? 
 
    return createCommand @xmpp, @messageName, @message
  
  # Listen for call events and re-emit them
  listen: (callid) ->
    @xmpp.on callid, (name, cmd) => @emit name, cmd if callid?

module.exports = RayoCommand
