
>> Given a Connection object with valid credentials

  path = require 'path'
  rayo = require path.join process.cwd(), 'src/rayo'
  log = require 'node-log'
  log.setName 'rayo-test'

  conn = new rayo.Connection
    host: 'telefonica115.orl.voxeo.net'
    jabberId: 'contrahax@jabber.org'
    jabberPass: 'testpass'
    verbose: false

>> When we call connect()

  conn.connect()

>> And a listener is setup for a 'connected' event

  conn.on 'connected', ->

>> Then conn.connected should be true

    conn.connected.should.be.true


#   @mock conn




#    @mock console.log conn

#  conn.on 'error', (err) -> log.error err.message
#  conn.on 'disconnected', -> log.info 'Connection closed'


#    conn.send new rayo.Dial(to: 'sip:contracontra@sip2sip.info', from: 'sip:test@whadupdoe.net'), (err, resp) ->
#      console.log resp
#      log.info 'Call placed. ID: ' + resp.childAttributes.id

###
    conn.on 'ringing', (cmd) -> log.info 'Call ' + resp.childAttributes.id + ' is ringing...'
    conn.on 'answered', (cmd) -> log.info 'Call ' + resp.childAttributes.id + ' picked up!'
    conn.on 'dtmf', (cmd) -> log.info 'Call ' + resp.childAttributes.id + ' pressed ' + cmd.childAttributes.signal
    conn.on 'end', (cmd) -> log.info 'Call ended, reason: ' + Object.keys(cmd.children)[0]

