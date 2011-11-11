>> Given a mock connection object

  mockConnection =
    host : "localhost"
    port : "8080"
    jabberId : "wearefractal@jabber.org"
    jabberPass : "boo"
    verbose : false

>> When we try to make an XMPPClient

  test = new XMPPClient mockConnection

>> Then we have a fully wired up xmpp client ready to listen and emit events

  test.xmppClient.host.should.eql "localhost"
  test.xmppClient.port.should.eql "8080"
  test.xmppClient.jabberId.should.eql "wearefractal@jabber.org"
  test.xmppClient.jabberPass.should.eql "jabberPass"

