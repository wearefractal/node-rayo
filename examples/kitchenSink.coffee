rayo = require '../src/rayo'
log = require 'node-log'
log.setName 'rayo-test'

conn = new rayo.Connection
  host: 'telefonica115.orl.voxeo.net'
  jabberId: 'wearefractal@jabber.org'
  jabberPass: 'ill4jabber'
  verbose: true

conn.on 'error', (err) -> log.error err.message
conn.on 'connected', ->
  log.info 'Connected!'
  conn.send new rayo.Dial(to: 'sip:codexrex@sip2sip.info', from: 'sip:test@whadupdoe.net'), (err, resp) ->
    log.info 'Call placed. ID: ' + resp.childAttributes.id

    conn.on 'ringing', (cmd) -> log.info 'Call ' + resp.childAttributes.id + ' is ringing...'
    conn.on 'answered', (cmd) -> log.info 'Call ' + resp.childAttributes.id + ' picked up!'
    conn.on 'dtmf', (cmd) -> log.info 'Call ' + resp.childAttributes.id + ' pressed ' + cmd.childAttributes.signal
    conn.on 'end', (cmd) -> log.info 'Call ended, reason: ' + Object.keys(cmd.children)[0]

  conn.on 'offer', (cmd) ->
    #conn.send new rayo.Answer offer: cmd
    conn.send new rayo.Reject offer: cmd, reason: 'busy'

conn.on 'disconnected', -> log.info 'Connection closed'

conn.connect()
