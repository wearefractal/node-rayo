Iq = require '../iq'

class Dial extends Iq
  constructor: ({@id, @to, @from}) ->
    @id ?= '1234' + Math.floor Math.random()*101 # id ?= 1234[0-100]
    super type: 'dial'
    message:
      id: @id
      to: '$callserver'
      from: '$localuser'
    attributes: 
      to: @to
      from: @from

module.exports = Dial
