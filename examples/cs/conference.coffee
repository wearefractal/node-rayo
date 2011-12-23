rayo = require '../rayo'
rayoConfig = require './config'
log = require 'node-log'
log.setName 'rayo-test'

# Create a connection object
conn = new rayo.Connection rayoConfig

conn.on 'connected', ->
  log.info 'Connected!'
  
  # Create the call commands
  call = conn.create 'dial',
    to: 'sip:contracontra@sip2sip.info'
    from: 'sip:rayo@test.net'
    
  call2 = conn.create 'dial',
    to: 'sip:contracontra2@sip2sip.info'
    from: 'sip:rayo@test.net'
  
  # Send the call commands to the server
  conn.send call, (cmd) -> 
    call.listen cmd.id
    call.callid = cmd.id
    call.on 'answered', ->
      log.info "Call 1 answered!"
      conn.send call2, (cmd) ->
        call2.listen cmd.id
        call2.callid = cmd.id
        call2.on 'answered', ->
          log.info "Call 2 answered!"
          join = conn.create 'join',
            callid: call.callid
            'call-id': call2.callid
            direction: 'duplex'
            media: 'bridge'
          conn.send join, (cmd) -> log.info "Calls joined into conference"

# Set up connection related event handlers
conn.on 'disconnected', -> log.info 'Connection closed'
conn.on 'error', (err) -> log.error err.message

conn.connect()
