xmpp = require 'node-xmpp'
static = require './static'

class Presence
  constructor: ({@type, @message, @headers, @attributes, @children}) ->
    throw new Error 'Type required for Iq!' unless @type
    @attributes ?= {}
    @message ?= {}
    @headers ?= {}
    @children ?= {}
    @attributes.xmlns ?= static.xmlns
    
  getId: -> return @message.id
  getElement: (jid) ->
    if @message.from is "#{ jid.user }@#{ jid.domain }" then @message.from += "/#{ jid.resource }"
    el = new xmpp.Element 'presence', @message
    sub = el.c @type, @attributes
    sub.c(child) for child of @children
    sub.c('header', {name: head, value: @headers[head]}) for head of @headers # If we have headers, append all of them
    return el

module.exports = Presence
