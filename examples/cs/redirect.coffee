rayo = require '../rayo'
rayoConfig = require './config'
log = require 'node-log'
log.setName 'rayo-test'

# Create a connection object
conn = new rayo.Connection rayoConfig

conn.on 'connected', ->
  log.info 'Connected!'
  
  # Listen for offer command
  conn.on 'offer', (cmd) ->
    log.info "Incoming call..."
    accept = conn.create 'accept', callid: cmd.callid
    redirect = conn.create 'reject',
      callid: cmd.callid
      redirect: 
        to: 'tel:+14802515171'
      header:[{"x-skill":"agent"}, {"x-customer-id":"8877"}]
      
    conn.send accept
    conn.send redirect
    log.info "Redirected call"

# Set up connection related event handlers
conn.on 'disconnected', -> log.info 'Connection closed'
conn.on 'error', (err) -> log.error err.message

conn.connect()
