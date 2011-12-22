_ = require('slice') __dirname
config = _.load 'commands.config'

parseCommand = (message) ->
  cmd = message.iq || message.presence
  return null unless cmd? # If message isn't iq or presence then drop it
  callid = cmd['@from']?.split('@')[0] if cmd['@from']?.indexOf('@') > -1 # Parse callid from root @from attr
  msgid = cmd['@id']
  out = {}
  for key, value of cmd
    if typeof value is 'object' # Main command, should be first key/val
      out[key] = {}
      out[key].msgid = msgid if msgid?
      out[key].callid = callid if callid?
      out[key][k.replace('@', '')] = v for k, v of value when v isnt config.xmlns
      if out[key].header? # Format headers
        for obj in out[key].header
          obj[obj['@name']] = obj['@value']
          delete obj['@name']
          delete obj['@value']
  return out
  
module.exports = parseCommand
