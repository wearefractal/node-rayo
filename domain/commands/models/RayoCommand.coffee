_ = require('slice') __dirname
{EventEmitter} = _.load 'events'
createCommand = _.load 'commands.createCommand'

class RayoCommand extends EventEmitter
  constructor: (@messageName, @message) ->
    @[prop] = val for prop, val of @message # Extend message
    
  getElement: (xmpp) -> # This gets called on send to form the actual command
    xmpp.once @msgid, (name, cmd) => @emit name, cmd if callid? # Single response event
    xmpp.on @callid, (name, cmd) => @emit name, cmd if callid? # All relevant call events
    return createCommand xmpp, @messageName, @mesage

module.export = RayoCommand
