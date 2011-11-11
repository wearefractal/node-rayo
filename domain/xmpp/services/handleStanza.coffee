_ = require 'slice'

getMessage        = _.load 'message.services.getMessage'
handleStanzaError = _.load 'xmpp.services.handleStanzaError'


handleStanza = (stanza, connection) ->

  if connection.xmppClient.verbose
    console.log 'Receiving inbound message: ' + stanza

   # throw new Error "Message from unknown domain #{ stanza.attrs.from.domain }" unless stanza.attrs.from.domain is @xmppClient.server

  if stanza.attrs.type is 'error'
    return handleStanzaError stanza, connection

  message = getMessage stanza
  #  connection.xmppClient.emit 'message', message # Emits 'message' with formatted stanza
  # change to message queue direct interaction

module.exports = handleStanza

