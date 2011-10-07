iq = require '../iq'

class Accept
  constructor: () ->

  getRaw: ->
    return new iq
      type: 'accept'

