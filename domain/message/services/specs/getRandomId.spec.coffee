#>> Setup

_ = require 'slice'
getRandomId = _.load 'message.services.getRandomId'

#>> When I try to create a random number

result = getRandomId()
result2 = getRandomId()

#>> Then the result should be a number

should = require 'should'
result.should.be.a "string"
result2.should.not.equal result

