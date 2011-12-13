_ = require 'slice'
stanzaToRayoCommand = _.load 'commands.stanzaToRayoCommand'

handleRayoMessage = (eventRouter, callbackRouter, stanza) ->

  if stanza.attrs.type is 'error'
    # handleRayoError
    # does this affect callback routing?
  else
    stanzaToRayoCommand stanza, (command) ->
      callbackRouter = callbackRouter.call command.id
      eventRouter.emit 'repeat'
        name: command.name
        object: command

  return callbackRouter


module.exports = handleRayoMessage
