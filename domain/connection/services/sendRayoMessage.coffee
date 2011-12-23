RayoCommand = require '../../commands/models/RayoCommand'

sendRayoMessage = (xmpp, cmd, callback) ->

  return null unless cmd instanceof RayoCommand

  if callback? and typeof callback is 'function'
    xmpp.once cmd.msgid, callback 

  xmpp.send cmd.getElement(xmpp)

module.exports = sendRayoMessage
