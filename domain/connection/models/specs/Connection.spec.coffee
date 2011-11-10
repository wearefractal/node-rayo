>> Setup

  _ = require 'slice'
  Connection = _.load 'connection.models.Connection'

>> When I try to create a Connection

  conn = new Connection
    host: 'telefonica115.orl.voxeo.net'
    jabberId: 'wearefractal@jabber.org'
    jabberPass: 'ill4jabber'
    verbose: true

>> Then it should be created ok

  conn.should.be.ok

>> When I try to create a Connection with a port in the host

  conn = new Connection
    host: 'telefonica115.orl.voxeo.net:8080'
    jabberId: 'wearefractal@jabber.org'
    jabberPass: 'ill4jabber'
    verbose: true

>> Then it should split it out ok

  conn.port.should.equal '8080'

