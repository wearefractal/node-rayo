Message = require '../message'

class Redirect extends Message
  constructor: ({@offer, @to}) ->
    throw new Error 'Missing "offer" parameter' unless @offer
    throw new Error 'Missing "to" parameter' unless @to
    super 
      rootName: 'iq'
      childName: 'redirect'
      rootAttributes: 
        id: @offer.rootAttributes.id
        to: @offer.rootAttributes.from
        from: @offer.rootAttributes.to
      childAttributes:
        to: @to
      
module.exports = Redirect
