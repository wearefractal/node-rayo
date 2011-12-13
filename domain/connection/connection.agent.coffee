_ = require 'slice'

EventEmitter   = _.load('events').EventEmitter
CallbackRouter = _.load 'CallbackRouter'
Jab            = _.load 'jab'

handleRayoMessage = _.load 'connection.handleRayoMessage'


class ConnectionAgent extends EventEmitter

  constructor: (@connection) ->

    #@connection = checkConnection connection    

    ## Collaborators
    
    @callbackRouter = new CallbackRouter()
    @eventRouter = new EventEmitter()
    @xmpp = new Jab connection

    ## Events

    @xmpp.on 'stanza', (stanza) -> 
      @callbackRouter = handleRayoMessage @eventRouter, @callbackRouter, stanza  
    @xmpp.on 'connected', -> @emit 'connected'
    @xmpp.on 'disconnected', -> @emit 'disconnected'
    @xmpp.on 'error', (error) -> @emit 'error', error

    @eventRouter.on 'repeat', (event) -> @emit event.name, event.object

  ## Services

  connect:    -> @xmpp.connect()
  disconnect: -> @xmpp.disconnect()

  send: (command, callback) -> 
    @callbackRouter = send @xmpp, @callbackRouter, command, @connection.status, callback 



module.exports = Connection
