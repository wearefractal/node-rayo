_ = require('slice') __dirname
parseCommand = _.load 'commands.parseCommand'

handleRayoMessage = (eventRouter, xmpp, stanza) ->
  cmd = parseCommand stanza
  return unless cmd? # Drop message if parsing failed
  name = Object.keys(cmd)[0]
  msg = cmd[name]
  xmpp.emit msg.msgid, name, msg if msg.msgid? # Emit messageId for callback queue
  xmpp.emit msg.callid, name, msg if msg.callid? # Emit call id
  eventRouter.emit 'emit', name, msg # Emit command name from agent
  
module.exports = handleRayoMessage
