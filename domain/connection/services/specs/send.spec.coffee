#unit #smoke

>> Setup

  _ = require 'slice'
  send = _.load 'connection.services.send'

>> Given some sample data

  command = _.sample 'command.models.Command'
  callback = -> # do nothing
  connection = _.sample 'connection.models.Connection'

>> When I call the send service with mock data

  result = send command, callback, connection

>> It should run ok

  result.should.be.ok

