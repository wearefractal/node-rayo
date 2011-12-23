#>> Setup

should = require 'should'
handleRayoMessage = require '../handleRayoMessage'
{EventEmitter} = require 'events'
xmpp = new EventEmitter
conn = new EventEmitter
eventRouter = new EventEmitter
eventRouter.on 'emit', (name, args...) -> conn.emit name, args

#>> Given a test offer message

offer = {"presence":{"@to":"9001@cool.com/1","@from":"call57@test.net/1","offer":{"@xmlns":"urn:xmpp:rayo:1","@to":"tel:+18003211212","@from":"tel:+13058881212","header":[{"@name":"Via","@value":"192.168.0.1"},{"@name":"Contact","@value":"192.168.0.1"}]}}}

#>> When I call handleRayoMessage

xmpp.on 'call57', (cmd) -> 
  cmd.to.should.be offer.presence.offer['@to']
handleRayoMessage eventRouter, xmpp, offer

