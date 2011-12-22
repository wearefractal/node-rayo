#>> Setup

_ = require('slice') __dirname
should = require 'should'
handleRayoMessage = _.load 'connection.handleRayoMessage'
{EventEmitter} = _.load 'events'
xmpp = new EventEmitter
conn = new EventEmitter

#>> Given a test offer message

offer = {"presence":{"@to":"9001@cool.com/1","@from":"call57@test.net/1","offer":{"@xmlns":"urn:xmpp:rayo:1","@to":"tel:+18003211212","@from":"tel:+13058881212","header":[{"@name":"Via","@value":"192.168.0.1"},{"@name":"Contact","@value":"192.168.0.1"}]}}}

#>> When I call handleRayoMessage

xmpp.on 'call57', (cb) -> cb.should.be.ok
conn.on 'offer', (cb) -> cb.should.be.ok

handleRayoMessage conn, xmpp, offer
