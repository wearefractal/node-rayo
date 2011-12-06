rayo = require '../src/rayo'
log = require 'node-log'
log.setName 'rayo-example'
  
conn = new rayo.Connection
  host: 'telefonica115.orl.voxeo.net'
  jabberId: 'contrahax@jabber.org'
  jabberPass: 'testpass'
  verbose: false
  
conn.on 'connected', ->
  log.info "Connection to #{conn.host} established"
  conn.send new rayo.Dial(to: 'sip:contracontra@sip2sip.info', from: 'sip:spoofed@whadupdoe.net'), (err, callA) ->
    # Do something with the response or error here
      
# Listen for call-related events
conn.on 'ringing', (cmd) -> log.info "Call #{cmd.getId()} is ringing..."
conn.on 'answered', (cmd) -> log.info "Call #{cmd.getId()} picked up!"
conn.on 'dtmf', (cmd) -> log.info "Call #{cmd.getId()} pressed #{cmd.childAttributes.signal}"
conn.on 'end', (cmd) -> log.info "Call #{cmd.getId()} ended, reason: #{Object.keys(cmd.children)[0]}"

# Connection related events
conn.on 'disconnected', -> log.info 'Connection closed'
conn.on 'error', (err) -> log.error err
  
# Connect to server and set it all in motion  
conn.connect()
