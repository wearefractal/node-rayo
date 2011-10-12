Iq = require '../iq'

class Dial extends Iq
  constructor: ({@to, @from}) ->
    super type: 'dial'
    attributes:
      to: to
      from: from

module.exports = Dial
