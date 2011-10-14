Iq = require '../iq'

class Dial extends Iq
  constructor: ({@to, @from}) ->
    super type: 'dial'
    message:
      id: '1234'
      to: '$callserver'
      from: '$localuser'
    attributes: 
      to: @to
      from: @from

module.exports = Dial
