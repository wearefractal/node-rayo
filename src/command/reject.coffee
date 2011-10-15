Message = require '../message'

class Reject extends Message
  constructor: ({@offer, @reason}) ->
    throw new Error 'Missing "offer" parameter' unless @offer
    @reason ?= 'decline'
    super 
      rootName: 'iq'
      childName: 'reject'
      rootAttributes: 
        id: @offer.rootAttributes.id
        to: @offer.rootAttributes.from
        from: @offer.rootAttributes.to
      children: [@reason]
      
module.exports = Reject
