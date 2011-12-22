_ = require 'slice'
isFunction = _.load('rzr-util').isFunction
rayoCommandToStanza = _.load 'commands.rayoCommandToStanza'
RayoCommand = _.load 'commands.RayoCommand'

send = (xmpp, name, cmd, callback) ->
  return unless cmd instanceof RayoCommand
  if callback? and typeof callback is 'function'
    xmpp.on cmd.id, callback
  xmpp.send cmd.getElement()

module.exports = send
