#>> Setup

_ = require('slice') __dirname
should = _.load 'should'
parseCommand = _.load 'commands.parseCommand'
connection =
  host: 'test.net'
  jid:
    user: '9001'
    domain: 'cool.com'
    resource: '1'

#>> Given arguments for an incoming offer command

cmd = parseCommand {"presence":{"@to":"9001@cool.com/1","@from":"call57@test.net/1","offer":{"@xmlns":"urn:xmpp:rayo:1","@to":"tel:+18003211212","@from":"tel:+13058881212","header":[{"@name":"Via","@value":"192.168.0.1"},{"@name":"Contact","@value":"192.168.0.1"}]}}}

#>> Then

cmd.should.eql "offer":{"callid":"call57", "to": "tel:+18003211212", "from": "tel:+13058881212", "header": [{"Via":"192.168.0.1"}, {"Contact":"192.168.0.1"}]}

#>> Given arguments for an incoming result command

resCmd = parseCommand {"iq":{"@id":"123456", "@type":"result", "@to":"9001@cool.net/1", "@from":"test.net", "ref":{"@id":"call57"}}}

#>> Then

resCmd.should.eql "ref":{"msgid":"123456", "id":"call57"}
