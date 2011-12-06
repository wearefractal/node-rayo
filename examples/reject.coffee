rayo = require '../src/rayo'
log = require 'node-log'
log.setName 'rayo-example'
  
conn = new rayo.Connection
  host: 'telefonica115.orl.voxeo.net'
  jabberId: 'contrahax@jabber.org'
  jabberPass: 'testpass'
  verbose: false
  
conn.on 'connected', -> log.info "Connection to #{conn.host} established"
      
# Listen for incoming calls
conn.on 'offer', (cmd) -> 
  conn.send new rayo.Reject(offer: cmd, reason: 'busy'), (err, res) -> 
    log.info "Call #{cmd.getId()} rejected."
      
conn.on 'end', (cmd) -> log.info "Call #{cmd.getId()} ended, reason: #{Object.keys(cmd.children)[0]}"

# Connection related events
conn.on 'disconnected', -> log.info 'Connection closed'
conn.on 'error', (err) -> log.error err
  
# Connect to server and set it all in motion  
conn.connect()
