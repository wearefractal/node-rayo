#>> Setup

  should = require 'should'
  _ = require 'slice'
  rayoCommandToStanza = _.load 'commands.rayoCommandToStanza'

#>> Given some mocks

  xmppClient = {}
    
  command = 
    name: 'dial'
    to: 'sip:contracontra@sip2sip.info'
    from: 'sip:spoofed@whadupdoe.net'   
 
#>> When I call rayoCommandToStanza

rayoCommandToStanza xmppClient, command, (stanza) ->

  stanza.should.equal somePredefinedStanza

  
