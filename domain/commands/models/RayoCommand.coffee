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
    if @msgid?
      @xmpp.once @msgid, (name, cmd) => @emit name, cmd
        
    if @callid?    
      @listen(@callid)
 
    return createCommand @xmpp, @messageName, @message
  
  # Listen for call events and re-emit them
  listen: (callid) ->
    if callid?
      @xmpp.on callid, (name, cmd) => @emit name, cmd

module.exports = RayoCommand
