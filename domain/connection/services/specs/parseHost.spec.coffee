>> Setup

  _ = require 'slice'
  parseHost = _.load 'connection.services.parseHost'
  config = _.load 'connection.config'


>> When I call parseHost with no arguments

  {host, port} = parseHost()

>> Then it should return the defaults

  host.should.equal config.default.host
  port.should.equal config.default.port


>> Given a host and a port

  host = "telefonica.23423.21"
  port = "1337"

>> When I call call parseHost

  {host, port} = parseHost host, port

>> Then it should just return them

  host.should.equal "telefonica.23423.21"
  port.should.equal "1337"


>> Given a hostname with a port in the url

  host = "telefonica115.orl.voxeo.net:8080"

>> When I call parseHost

  {host, port} = parseHost host

>> Then it should parse them out

  host.should.equal "telefonica115.orl.voxeo.net"
  port.should.equal "8080"

