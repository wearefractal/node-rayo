_ = require 'slice'
isFunction = _.load 'util.services.isFunction'

send = (xmppClient, command, callback) ->

  element = command.getElement xmppClient.host, xmppClient.jid

  if isFunction callback
    if @verbose then console.log 'Sending outbound message: ' + element.toString()
    connection.addCommand command.getId(), callback

  connection.xmppClient.send element


module.exports = send

