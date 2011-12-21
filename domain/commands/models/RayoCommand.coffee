{EventEmitter} = require 'events'

class RayoCommand extends EventEmitter
  constructor: (connection, @name, message) ->
    @[prop] = val for prop, val of message
    connection.on @id, (cmd) => @emit @name, cmd
    
module.export = RayoCommand
