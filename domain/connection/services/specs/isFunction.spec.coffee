>> Setup

  _ = require 'slice'
  isFunction = _.load 'connection.services.isFunction'
#  isFunction = _.load 'rzr.util.isFunction'

>> Given a function

  func = -> console.log "hi!"

>> Then isFunction should return true

  isFunction( func ).should.be.true

>> Given an object

  obj = {var: 1, var: 2}

>> Then isFunction should return false

  isFunction( obj ).should.be.false

