
>> Setup dependency libraries

  path = require 'path'
  rayo = require path.join process.cwd(), 'src/rayo'

>> Given a Connection object with valid credentials

  conn = new rayo.Connection
    xmpp: require path.join process.cwd(), 'mocks/node-xmpp'
    host: 'telefonica115.orl.voxeo.net'
    jabberId: 'valid@jabber.org'
    jabberPass: 'valid***'
    verbose: true

>> When we connect

  conn.connect()

>> And an 'online' event is emitted

  conn.xmppClient.emit 'online'

>> Then conn should be connected

  conn.connected.should.be.true

