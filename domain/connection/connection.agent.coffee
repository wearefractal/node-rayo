_ = require 'slice'

{EventEmitter} = _.load 'events'
Jab = _.load 'jab'
RayoCommand = _.load 'commands.RayoCommand'

handleRayoMessage = _.load 'connection.handleRayoMessage'
createMessage = _.load 'commands.createMessage'
parseMessage = _.load 'commands.parseMessage'

class ConnectionAgent extends EventEmitter

  constructor: (@connection) ->

    ## Collaborators
    
    @xmpp = new Jab connection
    @eventRouter = new EventEmitter
    
    ## Events

    @xmpp.on 'stanza', (stanza) -> handleRayoMessage @xmpp, stanza  
    @xmpp.on 'connected', -> @emit 'connected'
    @xmpp.on 'disconnected', -> @emit 'disconnected'
    @xmpp.on 'error', (error) -> @emit 'error', error

  ## Services

  connect: -> @xmpp.connect()
  disconnect: -> @xmpp.disconnect()

  send: (command, callback) -> send @xmpp, command, callback

  create: (name, command) -> return new RayoCommand name, command

module.exports = Connection
