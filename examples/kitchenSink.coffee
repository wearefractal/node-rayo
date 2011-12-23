rayo = require '../rayo'
log = require 'node-log'
log.setName 'rayo-test'

conn = new rayo.Connection
  host: 'telefonica115.orl.voxeo.net'
  jabberId: 'wearefractal@jabber.org'
  jabberPass: 'ill4jabber'
  #debug: true
  ping: true

conn.on 'error', (err) -> log.error err.message
conn.on 'connected', ->
  log.info 'Connected!'

  dial = conn.create 'dial',
    to: 'tel:+14802525373'
    from: 'tel:+14802525372'
    ###
    to: 'sip:contracontra@sip2sip.info'
    from: 'sip:rayo@test.net'
    ###
  dial.on 'ringing', (cmd) -> log.info "Call ringing..."
  dial.on 'answered', (cmd) -> log.info "Call answered!"
  dial.on 'end', (cmd) -> log.info "Call ended"
  conn.send dial, (cmd) -> 
    dial.listen(cmd.ref.id)
    log.info "Call placed with ID: #{cmd.ref.id}"

    
conn.on 'disconnected', -> log.info 'Connection closed'

conn.connect()
