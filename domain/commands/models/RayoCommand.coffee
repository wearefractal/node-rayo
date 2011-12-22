{EventEmitter} = require 'events'

class RayoCommand extends EventEmitter
  constructor: (connection, @messageName, @message) ->
    @[prop] = val for prop, val of @message
    connection.on @id, (cmd) => @emit Object.keys(cmd)[0], cmd # When connection emits id relevant, re-emit command with proper message name

  getElement: ->
    
module.export = RayoCommand
