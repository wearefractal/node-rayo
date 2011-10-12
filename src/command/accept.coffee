Iq = require '../iq'

class Accept extends Iq
  constructor: ({@offer}) ->
    super type: 'accept'
    message: 
      id: @offer.message.id
      to: @offer.message.from
      from: @offer.message.to

module.exports = Accept
