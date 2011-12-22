_ = require('slice') __dirname
RayoCommand = _.load 'commands.RayoCommand'
generateId = _.load 'commands.generateId'
config = _.load 'commands.config'

# Create an outgoing object to be parsed with xmlson
createCommand = (connection, name, args) ->
  connection = connection.xmppClient unless connection.jid? # node-xmpp stupid hack
  args.xmlns ?= config.xmlns
  command = {}
  # Root message attributes
  command['@id'] = generateId() # '123456'
  command['@type'] = 'set'
  command['@to'] = if args.callid? then "#{args.callid}@#{connection.host}/1" else connection.host
  command['@from'] = "#{connection.jid.user}@#{connection.jid.domain}/#{connection.jid.resource}"
  delete args.callid # Sanitize
  
  # Command attributes
  command[name] = {}
  for attr, value of args
    if typeof value is 'object' # Child
      if Array.isArray value # Multiple children
        command[name][attr] = []
        for item in value
          if attr is 'header' # SIP headers
            command[name][attr].push {'@name': key, '@value': val} for key, val of item
          else # Multiple children with text and/or attributes
            for key, val of item when key isnt 'text'
              delete item[key]
              item["@#{key}"] = val
            command[name][attr].push item
      else # Single child w/ optional text
        for key, val of value when key isnt 'text'
          delete value[key]
          value["@#{key}"] = val
        if value.text? and Object.keys(value).length is 0
          command[name][attr] = value.text
        else 
          command[name][attr] = value
    else # Attribute of command
      command[name]["@#{attr}"] = value
  stanza = iq: command
  return stanza
  
module.exports = createCommand
