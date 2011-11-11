_ = require 'slice'
config = _.load 'connection.config'

parseHost = (host, port) ->

  host ?= config.default.host
  port ?= config.default.port

  portInHost = -> return host.contains ':'

  # Split out the port if they put it in the server
  if portInHost()
    [host, port] = host.split ':'

  return { host: host, port: port }


module.exports = parseHost

