parseCommand = require '../../commands/services/parseCommand'

handleRayoMessage = (eventRouter, xmpp, stanza) ->
  cmd = parseCommand stanza
  return unless cmd? and typeof cmd is 'object'
  keys = Object.keys cmd
  return unless keys.length > 0 # Drop message if parsing failed
  name = keys[0]
  msg = cmd[name]
  console.log "Incoming #{name}: #{JSON.stringify(msg)}"
  return xmpp.ping() if name is 'ping'
  xmpp.emit msg.msgid, cmd if msg.msgid? # Emit messageId for callback queue
  xmpp.emit msg.callid, cmd if msg.callid? # Emit call id
  eventRouter.emit 'emit', name, msg # Emit command name from agent
  
module.exports = handleRayoMessage
