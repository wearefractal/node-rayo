rayo = require '../src/rayo'
log = require 'node-log'
log.setName 'rayo-test'

conn = new rayo.Connection
  host: 'jabber.org'
  jabberId: 'contrahax@jabber.org'
  jabberPass: 'testpass'

log.debug conn
conn.on 'error', (err) -> log.error err.message
conn.on 'connected', ->
  log.info 'Connected!'
  conn.on 'offer', (cmd) ->
    conn.send new rayo.Accept(offer: cmd), (err, resp) -> 
      log.error err.message if err
      pickup = -> conn.send new rayo.Answer(offer: cmd), (err, resp) -> log.error err.message if err
      setTimeout pickup, 7000 # Ring for 10 seconds
        
  conn.on 'end', (cmd) ->
    conn.disconnect()
    console.log 'Call ended, reason: ' + Object.keys(cmd.children)[0]
conn.connect()

