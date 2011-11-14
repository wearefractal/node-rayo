_ = require 'slice'
config = _.load 'message.config'
getRandomId = _.load 'message.services.getRandomId'
getElement = _.load 'message.services.getElement'

class Message
  constructor: ({@rootName, @rootAttributes, @childName, @childAttributes, @sipHeaders, @children}) ->
    throw new Error 'Missing rootName' unless @rootName
    throw new Error 'Missing childName' unless @childName
    @childAttributes ?= {}
    @rootAttributes ?= {}
    @sipHeaders ?= {}
    @children ?= []
    if @rootName is 'iq' then @rootAttributes.type ?= 'set'
    @rootAttributes.id ?= getRandomId()
    @childAttributes.xmlns ?= config.xmlns

  getId: -> return @rootAttributes.id
  getElement: (server, jid) -> getElement @, server, jid


module.exports = Message

