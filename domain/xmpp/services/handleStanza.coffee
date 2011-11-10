_ = require 'slice'
getMessage = _.load 'connection.xmpp.services.getMessage'
handleStanzaError = _.load 'connection.xmpp.services.handleStanzaError'

handleStanza = (stanza, connection) ->
#  @emit 'stanza', stanza # Emits 'stanza' with raw stanza
  if connection.xmppClient.verbose then console.log 'Receiving inbound message: ' + stanza
  # throw new Error "Message from unknown domain #{ stanza.attrs.from.domain }" unless stanza.attrs.from.domain is @xmppClient.server
  if stanza.attrs.type is 'error' then return handleStanzaError stanza, connection
  #xmppClient.emit stanza.name, stanza # Emits 'iq' or 'presence' with raw stanza
  message = getMessage stanza
  connection.xmppClient.emit message.childName, message # Emits command name with formatted stanza
  console.log message
  connection.xmppClient.emit 'message', message # Emits 'message' with formatted stanza

module.exports = handleStanza

