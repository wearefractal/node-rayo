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
    ask = conn.create 'ask', 
      callid: cmd.callid
      xmlns: 'urn:xmpp:tropo:ask:1'
      bargein: 'true'
      'min-confidence': '0.3'
      mode: 'speech|dtmf|any'
      recognizer: 'en-US'
      terminator: '#'
      timeout: '12000'
      prompt: 
        voice: 'allison'
        text: 'Please enter your four digit pin'
      choices: 
        'content-type': 'application/grammar+voxeo'
        text: '[4 DIGITS]'
      
    ask.on 'complete', (cmd) -> 
      if cmd.success
        result = cmd.success.interpretation
        console.log "User input was #{result}"
    
    conn.send accept
    conn.send answer
    log.info "Answered call"
    
    conn.send ask, (cmd) -> ask.listen cmd.id

# Set up connection related event handlers
conn.on 'disconnected', -> log.info 'Connection closed'
conn.on 'error', (err) -> log.error err.message

conn.connect()
