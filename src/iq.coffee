xmpp = require 'node-xmpp'
static = require './static'

class Iq
  constructor: ({@type, @message, @headers, @attributes, @child}) ->
    throw new Error 'Type required for Iq!' unless @type
    @attributes ?= {}
    @attributes.xmlns ?= static.xmlns

  getId: -> return @id
  getElement: ->
    el = new xmpp.Element 'iq', @message
    sub = el.c @type, @attributes # Append our main attributes to our message. Id, to, from, etc.
    if @child? then sub.c @child # If we have a child, append it
    if @headers? then sub.c('header', head) for head in @headers # If we have headers, append all of them
    # TODO: FINISH THIS

