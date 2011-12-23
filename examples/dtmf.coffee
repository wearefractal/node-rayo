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
    answer = conn.create 'answer', callid: cmd.callid
    dtmf = conn.create 'dtmf', callid: cmd.callid, tones: '32132111112222321'
    
    conn.send accept
    conn.send answer
    log.info "Answered call"
    conn.send dtmf
    conn.on 'dtmf', (cmd) -> log.info "User pressed #{cmd.signal}"

# Set up connection related event handlers
conn.on 'disconnected', -> log.info 'Connection closed'
conn.on 'error', (err) -> log.error err.message

conn.connect()
