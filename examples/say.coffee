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
    say = conn.create 'say', 
      callid: cmd.callid
      xmlns: 'urn:xmpp:tropo:say:1'
      voice: 'allison'
      audio: [
        {src: 'http://youarefloating.com/beats/Favella%20Dwella/bossa%20tek.mp3'},
        {src: 'http://youarefloating.com/beats/Soul%20Proprietor/i%20wish%20render%201.mp3'}
      ]
      #'say-as':{'interpret-as':'date', text: '12/01/2011'}
      
    say.on 'complete', (cmd) -> console.log cmd
    
    conn.send accept
    conn.send answer
    log.info "Answered call"
    
    conn.send say, (cmd) -> say.listen cmd.id

# Set up connection related event handlers
conn.on 'disconnected', -> log.info 'Connection closed'
conn.on 'error', (err) -> log.error err.message

conn.connect()
