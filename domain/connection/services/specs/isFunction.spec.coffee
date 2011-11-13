>> Setup

  _ = require 'slice'
  isFunction = _.load 'connection.services.isFuntion'

>> Given a function

  func = -> console.log "hi!"

>> Then

  isFunction( func ).should.be.true

