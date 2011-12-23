rayo = require '../rayo'
log = require 'node-log'
log.setName 'rayo-test'

conn = new rayo.Connection
  host: 'telefonica115.orl.voxeo.net'
  jabberId: 'wearefractal@jabber.org'
  jabberPass: 'ill4jabber'

conn.on 'error', (err) -> log.error err.message
conn.on 'connected', ->
  log.info 'Connected!'
  
  dial = conn.create 'dial', to: 'sip:contracontra@sip2sip.info', from: 'sip:node-rayo@test.net'
  dial.on 'ringing', (cmd) -> console.log "ringing resp: #{cmd}"
  dial.on 'answered', (cmd) -> console.log "answered resp: #{cmd}"
  conn.send dial, (cmd) -> console.log "dial resp: #{JSON.stringify(cmd)}"
  
  conn.on 'offer', (cmd) ->
    reject = conn.create 'reject', {callid: cmd.callid, busy:{}}
    conn.send reject, (cmd) -> console.log "reject resp: #{cmd}"
    
conn.on 'disconnected', -> log.info 'Connection closed'

conn.connect()
