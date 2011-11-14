Message = require '../message'

class Dial extends Message
  constructor: ({@to, @from}) ->
    super 
      rootName: 'iq'
      childName: 'dial'
      rootAttributes:
        to: '$callserver'
        from: '$localuser'
      childAttributes: 
        to: @to
        from: @from

module.exports = Dial
