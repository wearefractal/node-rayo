xmpp = require 'node-xmpp'
static = require './static'
util = require './util'

class Iq
  constructor: ({@type, @message, @headers, @attributes, @children}) ->
    throw new Error 'Type required for Iq!' unless @type
    @attributes ?= {}
    @message ?= {}
    @headers ?= {}
    @children ?= {}
    @message.type ?= 'set'
    @message.id ?= util.getRandomId() 
    @attributes.xmlns ?= static.xmlns

  getId: -> return @message.id
  getElement: (server, jid) ->
    if @message.to.contains '$callserver'
      @message.to = @message.to.replace '$callserver', server
      
    if @message.from is "#{ jid.user }@#{ jid.domain }" or "$localuser"
      @message.from = "#{ jid.user }@#{ jid.domain }/#{ jid.resource }"
    
    el = new xmpp.Element 'iq', @message
    sub = el.c @type, @attributes
    sub.c(child) for child of @children
    sub.c('header', {name: head, value: @headers[head]}) for head of @headers # If we have headers, append all of them
    return el

module.exports = Iq
