_ = require 'slice'

EventEmitter   = _.load('events').EventEmitter
Jab            = _.load 'jab'

handleRayoMessage = _.load 'connection.handleRayoMessage'
createMessage = _.load 'commands.createMessage'
parseMessage = _.load 'commands.parseMessage'

class ConnectionAgent extends EventEmitter

  constructor: (@connection) ->

    ## Collaborators
    
    @xmpp = new Jab connection

    ## Events

    @xmpp.on 'stanza', (stanza) -> 
      @callbackRouter = handleRayoMessage @eventRouter, @callbackRouter, stanza  
    @xmpp.on 'connected', -> @emit 'connected'
    @xmpp.on 'disconnected', -> @emit 'disconnected'
    @xmpp.on 'error', (error) -> @emit 'error', error

    @eventRouter.on 'repeat', (event) -> @emit event.name, event.object

  ## Services

  connect: -> @xmpp.connect()
  disconnect: -> @xmpp.disconnect()

  send: (command, callback) -> 
    @callbackRouter = send @xmpp, @callbackRouter, command, @connection.status, callback 

  create: (name, command) ->
    return createCommand @, name, command

module.exports = Connection
