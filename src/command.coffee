xmpp = require 'node-xmpp'
static = require './static'

class Command
  constructor: ({@type, @message, @headers, @attributes, @child}) ->
    throw new Error 'Type required for Command!' unless @type
    throw new Error 'jabberId required for Command!' unless @id
    @attributes ?= {}
    @attributes.xmlns ?= static.xmlns

  getId: -> return @id
  getElement: ->
    el = new xmpp.Element 'iq', @message
    sub = el.c @name, @attributes
    if @child? then sub.c @child
    if @headers? then sub.c 'header', head for head in @headers
    # TODO: FINISH THIS

