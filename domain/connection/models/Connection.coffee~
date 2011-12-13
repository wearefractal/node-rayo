_ = require 'slice'

JabClient      = _.load 'jab.JabClient'
EventEmitter   = _.load 'events.EventEmitter'
CallbackRouter = _.load 'connection.callbackRouter.CallbackRouter'
messageToRayoCommand = _.load 'connection.messageToRayoCommand'
rayoCommandToMessage = _.load 'connection.rayoCommandToMessage'

class Connection extends EventEmitter

  constructor: ({@host, @port, @jabberId, @jabberPass, @verbose, @status}) ->
 
    @xmppClient     = new JabClient arguments # shorthand for all incoming args
    @callbackRouter = new CallbackRouter()

    # on any event emitted by the jab xmpp client 
    # handle the incoming message

    @xmppClient.on '*', (message) -> handleRayoMessage @, message

      ##
      handleRayoMessage = (connection, message) ->
        messageToRayoCommand message, (command) ->
          connection.emit command.name, command
          connection.callbackRouter.find command.id

  connect: -> 
    @xmppClient.connect()
    @emit "connected"

  disconnect: -> 
    @xmppClient.disconnect()
    @emit "disconnected"

  send: (command, callback) -> send @, command, callback

    ##
    send = (connection, command, callback) ->
      rayoCommandToMessage command, (message) ->    
        connection.xmppClient.send message
        connection.callbackRouter.push command.id, callback


module.exports = Connection
