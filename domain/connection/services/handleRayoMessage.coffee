parseCommand = require '../../commands/services/parseCommand'

handleRayoMessage = (eventRouter, xmpp, stanza) ->
  cmd = parseCommand stanza
  return unless cmd? # Drop message if parsing failed
  name = Object.keys(cmd)[0]
  msg = cmd[name]
  console.log "Incoming #{name}: #{JSON.stringify(msg)}"
  xmpp.emit msg.msgid, cmd if msg.msgid? # Emit messageId for callback queue
  xmpp.emit msg.callid, cmd if msg.callid? # Emit call id
  eventRouter.emit 'emit', name, msg # Emit command name from agent
  
module.exports = handleRayoMessage
