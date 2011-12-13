>> Setup

  should = require 'should'
  _ = require 'slice'
  stanzaToRayoCommand = _.load 'commands.stanzaToRayoCommand'

>> Given some sample data

#>> Given some mocks

  xmppClient = {}
    
  stanza = mockStanza
 
#>> When I call stanzaToRayoCommand

stanzaToRayoCommand xmppClient, stanza, (command) ->

  command.should.equal somePredefinedCommand

    
