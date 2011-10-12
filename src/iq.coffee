xmpp = require 'node-xmpp'
static = require './static'

class Iq
  constructor: ({@type, @message, @headers, @attributes, @child}) ->
    throw new Error 'Type required for Iq!' unless @type
    @attributes ?= {}
    @message ?= {}
    @headers ?= []
    @message.type ?= 'set'
    @attributes.xmlns ?= static.xmlns

  getId: -> return @message.id
  getElement: ->
    el = new xmpp.Element 'iq', @message
    sub = el.c @type, @attributes # Append our main attributes to our message. Id, to, from, etc.
    sub.c @child if @child? # If we have a child, append it
    sub.c('header', {name: head, value: @headers[head]}) for head of @headers # If we have headers, append all of them

    return el

module.exports = Iq
