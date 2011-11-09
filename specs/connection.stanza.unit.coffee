
>> Setup dependency libraries

  path = require 'path'
  rayo = require path.join process.cwd(), 'src/rayo'

>> Given a mock presence stanza
  outbound = '<iq to="telefonica115.orl.voxeo.net" from="wearefractal@jabber.org/77d7aea6a5a17422" type="set" id="862e-4c52-b953-de18-0062"><dial to="sip:codexrex@sip2sip.info" from="sip:test@whadupdoe.net" xmlns="urn:xmpp:rayo:1"/></iq>
Receiving inbound message: <iq from="telefonica115.orl.voxeo.net" to="wearefractal@jabber.org/77d7aea6a5a17422" type="result" id="862e-4c52-b953-de18-0062" xmlns="jabber:client" xmlns:stream="http://etherx.jabber.org/streams"><ref id="d1ac9dac-be38-498a-ac8d-d006a5b4cf9c" xmlns="urn:xmpp:rayo:1"/></iq>'
  inbound = '<presence from="d1ac9dac-be38-498a-ac8d-d006a5b4cf9c@telefonica115.orl.voxeo.net" to="wearefractal@jabber.org" id="e4314e78-818a-44f0-a769-e8fd9be4eb3c" xmlns="jabber:client" xmlns:stream="http://etherx.jabber.org/streams"><end xmlns="urn:xmpp:rayo:1"><hangup/><header name="Max-Forwards" value="69"/><header name="Record-Route" value="&lt;sip:81.23.228.129;lr;ftag=cf03a039ea674068a6d351452e07ed7b&gt;"/><header name="Content-Length" value="0"/><header name="To" value="&lt;sip:test@whadupdoe.net&gt;;tag=10qf62rt0q6pj"/><header name="CSeq" value="5437 BYE"/><header name="Via" value="SIP/2.0/UDP 81.23.228.129;branch=z9hG4bK808c.bb97a89.0"/><header name="User-Agent" value="Blink 0.2.7 (Windows)"/><header name="Call-ID" value="15zsv7pf5dxy8"/><header name="From" value="&lt;sip:codexrex@sip2sip.info&gt;;tag=cf03a039ea674068a6d351452e07ed7b"/></end></presence>'

>> And we have a connected Connection object with valid credentials

  conn = new rayo.Connection
    xmpp: require path.join process.cwd(), 'mocks/node-xmpp'
    host: 'telefonica115.orl.voxeo.net'
    jabberId: 'valid@jabber.org'
    jabberPass: 'valid***'
    verbose: true
  conn.connect()


>> When we're connected, online, and a 'stanza' event is emitted

  conn.xmppClient.emit 'stanza', outbound

>> Then the message queue should have the xml response from the server added to it
  expectedResult = conn.getMessage  inbound
  console.log expectedResult
  array.should.contain expectedResult

