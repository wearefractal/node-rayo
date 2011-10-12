rayo = require '../src/rayo'
log = require 'node-log'
log.setName 'rayo-test'

conn = new rayo.Connection
  host: 'jabber.org'
  jabberId: 'contrahax@jabber.org'
  jabberPass: 'coding2424'

log.debug conn
conn.on 'error', (err) -> log.error err
conn.on 'connected', ->
  log.info 'Connected!'
  conn.on 'offer', (cmd) ->
    conn.send new rayo.Accept(offer: cmd), (err, resp) -> 
      log.error err.message if err
      log.info resp if resp
  # conn.disconnect()

conn.connect()

