rayo = require '../rayo'
rayoConfig = require './config'
log = require 'node-log'
log.setName 'rayo-test'

# Create a connection object
conn = new rayo.Connection rayoConfig

conn.on 'connected', ->
  log.info 'Connected!'
  
  # Create the call command
  dial = conn.create 'dial',
    to: 'sip:contracontra@sip2sip.info'
    from: 'sip:rayo@test.net'
  
  # Set up event listeners for the call
  dial.on 'ringing', (cmd) -> log.info "Call ringing..."
  dial.on 'answered', (cmd) -> log.info "Call answered!"
  dial.on 'end', (cmd) -> log.info "Call ended"
  
  # Send the call command to the server
  conn.send dial, (cmd) -> dial.listen cmd.id

# Set up connection related event handlers
conn.on 'disconnected', -> log.info 'Connection closed'
conn.on 'error', (err) -> log.error err.message

conn.connect()
