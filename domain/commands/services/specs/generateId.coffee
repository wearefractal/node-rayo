#>> Setup

_ = require('slice') __dirname
should = _.load 'should'
generateId = _.load 'commands.generateId'

#>> When generateId is called twice

id = generateId()
idN = generateId()

#>> Then

id.should.not.equal idN
