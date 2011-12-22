#>> Setup

_ = require('slice') __dirname
should = _.load 'should'
createCommand = _.load 'commands.createCommand'
connection =
  host: 'test.net'
  jid:
    user: '9001'
    domain: 'cool.com'
    resource: '1'

#>> Given arguments for an outgoing dial command

cmd = createCommand connection, 'dial', {to:"tel:+13055195825", from:"tel:+14152226789", header:[{"x-skill":"agent"}, {"x-customer-id":"8877"}]}

#>> Then

cmd.should.eql "iq":{"@id":cmd.iq['@id'],"@type":"set","@to":"test.net","@from":"9001@cool.com/1","dial":{"@xmlns": "urn:xmpp:rayo:1", "@to":"tel:+13055195825","@from":"tel:+14152226789","header":[{"@name":"x-skill","@value":"agent"},{"@name":"x-customer-id","@value":"8877"}]}}

#>> Given arguments for an outgoing reject command

cmd = createCommand connection, 'reject', {callid: 'call57', decline: {}, header:["x-reason-internal":"bad-skill"]}

#>> Then

cmd.should.eql {"iq":{"@id":cmd.iq['@id'],"@type":"set","@to":"call57@test.net/1","@from":"9001@cool.com/1","reject":{"@xmlns":"urn:xmpp:rayo:1","decline":{},"header":[{"@name":"x-reason-internal","@value":"bad-skill"}]}}}

#>> Given arguments for an outgoing say component command

cmd = createCommand connection, 'say', {callid: 'call57', xmlns: 'urn:xmpp:tropo:say:1', voice: 'allison', audio: [{src: 'http://acme.com/greeting.mp3', text:'Thanks for calling ACME company'}, {src: 'http://acme.com/package-shipped.mp3', text:'Your package was shipped on'}], 'say-as':{'interpret-as':'date', text: '12/01/2011'}}

#>> Then
cmd.should.eql {"iq":{"@id":cmd.iq['@id'],"@type":"set","@to":"call57@test.net/1","@from":"9001@cool.com/1","say":{"@xmlns":"urn:xmpp:tropo:say:1","@voice":"allison","audio":[{"@src":"http://acme.com/greeting.mp3","text":"Thanks for calling ACME company"},{"@src":"http://acme.com/package-shipped.mp3","text":"Your package was shipped on"}],"say-as":{"@interpret-as":"date","text":"12/01/2011"}}}}
