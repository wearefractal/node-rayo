xmpp = require 'node-xmpp'
static = require './static'
util = require './util'

class Message
  constructor: ({@rootName, @rootAttributes, @childName, @childAttributes, @sipHeaders, @children}) ->
    throw new Error 'Missing rootName' unless @rootName
    throw new Error 'Missing childName' unless @childName
      
    @childAttributes ?= {}
    @rootAttributes ?= {}
    @sipHeaders ?= {}
    @children ?= []
    if @rootName is 'iq' then @rootAttributes.type ?= 'set'
    @rootAttributes.id ?= util.getRandomId()
    @childAttributes.xmlns ?= static.xmlns

  getId: -> return @rootAttributes.id
  getElement: (server, jid) ->
    if @rootAttributes.to.indexOf '$callserver' > 0
      @rootAttributes.to = @rootAttributes.to.replace '$callserver', server
      
    if @rootAttributes.from is "#{ jid.user }@#{ jid.domain }" or "$localuser"
      @rootAttributes.from = "#{ jid.user }@#{ jid.domain }/#{ jid.resource }"
    
    el = new xmpp.Element @rootName, @rootAttributes
    sub = el.c @childName, @childAttributes
    sub.c(child) for child in @children
    sub.c('header', {name: head, value: @sipHeaders[head]}) for head of @sipHeaders # If we have headers, append all of them
    return el

module.exports = Message
