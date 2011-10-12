xmpp = require 'node-xmpp'
static = require './static'

class Iq
  constructor: ({@type, @message, @headers, @attributes, @children}) ->
    throw new Error 'Type required for Iq!' unless @type
    @attributes ?= {}
    @message ?= {}
    @headers ?= {}
    @children ?= {}
    @message.type ?= 'set'
    @attributes.xmlns ?= static.xmlns

  getId: -> return @message.id
  getElement: (jid) ->
    if @message.from is "#{ jid.user }@#{ jid.domain }" then @message.from += "/#{ jid.resource }"
    el = new xmpp.Element 'iq', @message
    sub = el.c @type, @attributes # Append our main attributes to our message. Id, to, from, etc.
    sub.c(child) for child in @children
    sub.c('header', {name: head, value: @headers[head]}) for head of @headers # If we have headers, append all of them
    return el

module.exports = Iq
