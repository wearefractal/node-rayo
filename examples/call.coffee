rayo = require '../src/rayo'
log = require 'node-log'
log.setName 'rayo-test'

conn = new rayo.Connection
  # host: 'jabber.org'
  jabberId: 'contrahax@jabber.org'
  jabberPass: 'testpass'
  verbose: false
  
conn.on 'error', (err) -> log.error err.message
conn.on 'connected', ->
  log.info 'Connected!'
  conn.send new rayo.Dial(to: 'sip:contracontra@sip2sip.info', from: 'sip:test@whadupdoe.net'), (err, resp) ->
    log.error err if err
    log.info 'Call ID: ' + resp.attributes.id
    conn.on 'ringing', (cmd) ->
      log.info 'Call ' + resp.attributes.id + ' is ringing...'
    
    conn.on 'answered', (cmd) ->
      log.info 'Call ' + resp.attributes.id + ' picked up!'
      conn.send new rayo.DTMF(callId: resp.attributes.id, tones: '123123123'), (err, resp) -> # mary had a little lamb
        log.error if err
        log.info resp if resp
          
    conn.on 'end', (cmd) ->
      log.info 'Call ended, reason: ' + Object.keys(cmd.children)[0]
          
  conn.on 'offer', (cmd) ->
    conn.send new rayo.Accept(offer: cmd), (err, resp) -> 
      log.error err.message if err
      pickup = -> conn.send new rayo.Answer(offer: cmd), (err, resp) -> log.error err.message if err
      setTimeout pickup, 7000 # Ring for 10 seconds
    
conn.connect()

