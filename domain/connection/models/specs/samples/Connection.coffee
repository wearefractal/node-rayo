_ = require 'slice'
Connection = _.load 'connection.models.Connection'

conn = new Connection
  host: 'telefonica115.orl.voxeo.net'
  jabberId: 'wearefractal@jabber.org'
  jabberPass: 'ill4jabber'
  verbose: true


module.exports = conn

