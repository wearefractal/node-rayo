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
      
    return createCommand @xmpp, @messageName, @message
      
  # Listen for call/component events and re-emit them
  listen: (id) ->
    id ?= @callid # If no callid passed in, check for local
    id ?= @componentid # If no callid passed in, check for local
    if id?
      @xmpp.on id, (name, cmd) => @emit name, cmd

module.exports = RayoCommand
