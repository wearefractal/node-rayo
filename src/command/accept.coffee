Iq = require '../iq'

class Accept extends Iq
  constructor: ({@offer}) ->
    super type: 'accept'
    message: 
      id: @offer.message.id
      to: @offer.message.to
      from: @offer.message.from

module.exports = Accept
