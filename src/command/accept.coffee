iq = require '../iq'

class Accept
  constructor: () ->
    return new iq
      type: 'accept'

