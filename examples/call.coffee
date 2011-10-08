rayo = require '../src/rayo'
log = require 'node-log'
log.setName 'rayo-test'

conn = new rayo.Connection
  jabberId: 'contrahax@jabber.org'
  jabberPass: 'notmypassword9001'

log.debug conn
conn.on 'error', (err) -> log.error err.message
conn.on 'connected', ->
  log.info 'Connected!'
  # conn.end()

conn.connect()

