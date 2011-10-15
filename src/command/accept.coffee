Message = require '../message'

class Accept extends Message
  constructor: ({@offer}) ->
    throw new Error 'Missing "offer" parameter' unless @offer
    super 
      rootName: 'iq'
      childName: 'accept'
      rootAttributes: 
        id: @offer.rootAttributes.id
        to: @offer.rootAttributes.from
        from: @offer.rootAttributes.to

module.exports = Accept
