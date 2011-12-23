require 'should'
Connection = require '../connection.agent'
rayoConfig = require '../../../examples/config'
log = require 'node-log'

#>> Given a Rayo connection

conn = new Connection rayoConfig

#>> When I connect

conn.on 'connected', ->
  log.info 'Connected!'
  
#>> And create a dial command

  dial = conn.create 'dial',
    to: 'sip:contracontra@sip2sip.info'
    from: 'sip:rayo@test.net'
  
#>> Then it should ring

  dial.on 'ringing', (cmd) => 
    log.info "Call ringing..."
    cmd.should.be.ok

#>> Cleanup

    clearTimeout @timeout
    conn.disconnect()

#>> Given a timeout

  delay = -> throw new Error 'rayo.dial: ringing timed out'
  @timeout = setTimeout delay, 8000 

#>> When I send the 'dial' command

  conn.send dial, (cmd) -> dial.listen cmd.id

#>> And connect the Rayo connection

conn.connect()
