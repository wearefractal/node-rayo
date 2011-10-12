xmpp = require 'node-xmpp'
static = require './static'

class Presence
  constructor: ({@type, @message, @headers, @attributes, @child}) ->
    @attributes ?= {}
    @attributes.xmlns ?= static.xmlns

  getElement: ->
    el = new xmpp.Element 'presence', @message
    sub = el.c @type, @attributes # Append our main attributes to our message. Id, to, from, etc.
    if @child? then sub.c @child # If we have a child, append it
    if @headers? then sub.c('header', head) for head in @headers # If we have headers, append all of them

    return el

module.exports = Presence
