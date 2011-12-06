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
    conn.on 'answered', (cmd) ->
      if cmd.getId() is callA.getId()
        log.info "Caller A answered, placing Call B"
        conn.send new rayo.Dial(to: 'sip:contracontra2@sip2sip.info', from: 'sip:spoofed@whadupdoe.net')
      else
        log.info "Caller B answered, joining them to conference"
        conn.send new rayo.Join(hoster: callA, joinee: cmd), (err, conference) -> log.debug conference
            
# Set up call related event handlers
conn.on 'ringing', (cmd) -> log.info "Call #{cmd.getId()} is ringing..."
conn.on 'end', (cmd) -> log.info "Call #{cmd.getId()} ended, reason: #{Object.keys(cmd.children)[0]}"

# Connection related events
conn.on 'disconnected', -> log.info 'Connection closed'
conn.on 'error', (err) -> log.error err
  
# Connect to server and set it all in motion  
conn.connect()
