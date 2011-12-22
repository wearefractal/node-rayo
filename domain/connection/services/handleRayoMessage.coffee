_ = require('slice') __dirname
parseCommand = _.load 'commands.parseCommand'

handleRayoMessage = (connection, xmpp, stanza) ->
  cmd = parseCommand stanza
  return unless cmd? # Drop message if parsing failed
  name = Object.keys(cmd)[0]
  xmpp.emit cmd.id, cmd
  connection.emit name, cmd
  
module.exports = handleRayoMessage
