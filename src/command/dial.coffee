iq = require '../iq'

class Dial
  constructor: ({@to, @from}) ->
    throw new Error 'DialCommand missing arguments' unless @to and @from
    return new iq
      type: 'dial'
      attributes:
        to: @to
        from: @from

