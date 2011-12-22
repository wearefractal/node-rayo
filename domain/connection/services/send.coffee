_ = require 'slice'
isFunction = _.load('rzr-util').isFunction
rayoCommandToStanza = _.load 'commands.rayoCommandToStanza'
RayoCommand = _.load 'commands.RayoCommand'

send = (xmpp, cmd, callback) ->
  return null unless cmd instanceof RayoCommand
  xmpp.once cmd.msgid, callback if callback? and typeof callback is 'function'
  xmpp.send cmd.getElement(xmpp)

module.exports = send
