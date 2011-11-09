getRandomId = ->
    rand = -> (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1)
    return "#{ rand() }-#{ rand() }-#{ rand() }-#{ rand() }-#{ rand() }"

module.exports = getRandomId

#>> When I try to create a random number
result = getRandomId()
#>> Then the result should be a number
should = require 'should'
result.should.be.a "number"

