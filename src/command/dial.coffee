Iq = require '../iq'

class Dial extends Iq
  constructor: ({@to, @from}) ->
    super type: 'dial'
    message:
      to: '$callserver'
      from: '$localuser'
    attributes: 
      to: @to
      from: @from

module.exports = Dial
