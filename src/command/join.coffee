Message = require '../message'

class Join extends Message
  constructor: ({@hoster, @joinee, @direction, @media}) ->
    throw new Error 'Missing "hoster" parameter' unless @hoster
    throw new Error 'Missing "joinee" parameter' unless @joinee
    @direction ?= 'duplex'
    @media ?= 'bridge'
    super 
      rootName: 'iq'
      childName: 'join'
      rootAttributes: 
        id: @joinee.getId()
        to: @joinee.getTo()
        from: @joinee.getFrom()
      childAttributes:
        "call-id": @hoster.getId()
        direction: @direction
        media: @media
        
module.exports = Join
