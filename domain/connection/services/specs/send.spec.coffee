>> Setup

  _ = require 'slice'
  send = _.load 'connection.services.send'

  command = _.mock 'commands.models.command'
  connection = _.mock 'conneciton.models.Connection'

>> When I call parseHost with no arguments


  send command, callback, connection

  {host, port} = parseHost()

>> Then it should return the defaults

  host.should.equal config.default.host
  port.should.equal config.default.port

