{EventEmitter} = require 'events'
Jab = require 'jab'

RayoCommand       = require '../commands/models/RayoCommand'
handleRayoMessage = require './services/handleRayoMessage'
sendRayoMessage   = require './services/sendRayoMessage'

class ConnectionAgent extends EventEmitter

  constructor: (@connection) ->

    ## Collaborators
    @xmpp = new Jab @connection
    @eventRouter = new EventEmitter
    
    ## Events
    @xmpp.on 'stanza', (stanza) =>
      handleRayoMessage @eventRouter, @xmpp, stanza  
    @xmpp.on 'connected', => @emit 'connected'
    @xmpp.on 'disconnected', => @emit 'disconnected'
    @xmpp.on 'error', (error) => @emit 'error', error
    @eventRouter.on 'emit', (event, args...) => @emit event, args
    
  ## Services

  connect: -> @xmpp.connect()
  disconnect: -> @xmpp.disconnect()

  send: (command, callback) -> sendRayoMessage @xmpp, command, callback

  create: (name, command) -> return new RayoCommand @xmpp, name, command


module.exports = ConnectionAgent
