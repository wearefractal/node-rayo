parseCommand = require '../../commands/services/parseCommand'

handleRayoMessage = (eventRouter, xmpp, stanza) ->
  cmd = parseCommand stanza
  return unless cmd? and typeof cmd is 'object'
  keys = Object.keys cmd
  return unless keys.length > 0 # Drop message if parsing failed
  name = keys[0]
  msg = cmd[name]
  return xmpp.ping() if name is 'ping'
  
  ## Clean up the object returned
  name = keys[0]
  msg = cmd[name]
  msg.msgtype = name
  
  # console.log "Incoming #{name}: #{JSON.stringify(msg)}"
  
  if msg.msgid? # Emit messageId for callback queue
    xmpp.emit msg.msgid, msg
    
  if msg.callid? # Emit call id
    xmpp.emit msg.callid, name, msg
  
  if msg.componentid? # Emit component id
    xmpp.emit msg.componentid, name, msg
      
  eventRouter.emit 'emit', name, msg # Emit command name from agent
  
module.exports = handleRayoMessage
