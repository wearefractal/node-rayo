_ = require 'slice'
isFunction = _.load('rzr-util').isFunction
rayoCommandToStanza = _.load 'commands.rayoCommandToStanza'

send = (xmppClient, callbackRouter, command, verbose, callback) ->

  rayoCommandToStanza xmppClient, command, (stanza) ->

    if isFunction callback
      if verbose 
        console.log 'Sending outbound message: ' + stanza.toString()
      callbackRouter = callbackRouter.push command.id, callback

    xmppClient.send stanzaTo
    return callbackRouter


module.exports = send
