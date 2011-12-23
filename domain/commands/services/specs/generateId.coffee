#>> Setup

should = require 'should'
generateId = require '../generateId'

#>> When generateId is called twice

id = generateId()
idN = generateId()

#>> Then

id.should.not.equal idN
