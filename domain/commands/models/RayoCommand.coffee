_ = require('slice') __dirname
{EventEmitter} = _.load 'events'
createCommand = _.load 'commands.createCommand'

class RayoCommand extends EventEmitter
  constructor: (@messageName, @message) ->
    @[prop] = val for prop, val of @message # Extend message
    
  getElement: (xmpp) -> # This gets called on send to form the actual command
    xmpp.on @id, (name, cmd) => @emit name, cmd # When connection emits id relevant, re-emit command with proper message name
    return createCommand xmpp, @messageName, @mesage

module.export = RayoCommand
