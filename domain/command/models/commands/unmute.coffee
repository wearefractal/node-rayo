Message = require '../message'

class Unmute extends Message
  constructor: ({@offer}) ->
    throw new Error 'Missing "offer" parameter' unless @offer
    super 
      rootName: 'iq'
      childName: 'unmute'
      rootAttributes: 
        id: @offer.rootAttributes.id
        to: @offer.rootAttributes.from
        from: @offer.rootAttributes.to

module.exports = Unmute
