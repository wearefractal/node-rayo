_ = require 'slice'
isFunction = _.load 'connection.services.isFunction'

send = (command, callback, connection) ->

  element = command.getElement connection.host, connection.xmppClient.jid
  if @verbose then console.log 'Sending outbound message: ' + element.toString()
  if isFunction
    connection.commandQueue.push command.getId(), callback

  connection.xmppClient.send element


module.exports = send

