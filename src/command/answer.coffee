Iq = require '../iq'

class Answer extends Iq
  constructor: ({@offer}) ->
    super type: 'answer'
    message: 
      id: @offer.message.id
      to: @offer.message.from
      from: @offer.message.to

module.exports = Answer
