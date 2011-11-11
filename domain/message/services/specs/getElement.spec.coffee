
>> Setup

  _ = require 'slice'

  Message    = _.load 'message.models.Message'
  getElement = _.load 'message.services.getElement'

>> When I try to build a Message

  message = new Message
    rootName: "presence"
    rootAttributes:
      from : "d1ac9dac-be38-498a-ac8d-d006a5b4cf9c@telefonica115.orl.voxeo.net"
      to : "wearefractal@jabber.org"
      id : "e4314e78-818a-44f0-a769-e8fd9be4eb3c"
      xmlns : "jabber:client"
      xmlns:stream : "http://etherx.jabber.org/streams"
    childName: "end"
  element = getElement(message, "telefonica115.orl.voxeo.net","wearefractal@jabber.org")

>> Then the element should be properly scaffolded

  message.rootName.should.eql "presence"
  id = message.getId()
  id.should.equal "e4314e78-818a-44f0-a769-e8fd9be4eb3c"

