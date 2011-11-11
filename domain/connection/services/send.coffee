send = (command, callback, connection) ->

  element = command.getElement connection.host, connection.xmppClient.jid
  if @verbose then console.log 'Sending outbound message: ' + element.toString()
  if callback? and typeof callback is 'function'
    connection.commandQueue.add command.getID(), callback

  connection.xmppClient.send element


module.exports = send

