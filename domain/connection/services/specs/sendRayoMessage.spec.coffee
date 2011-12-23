#>> Setup

should = require 'should'
sendRayoMessage = require '../sendRayoMessage'
{EventEmitter} = require 'events'
xmpp = new EventEmitter
