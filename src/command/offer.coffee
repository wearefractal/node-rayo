Presence = require '../presence'

class Offer extends Presence
  constructor: ({@to, @from}) ->
    throw new Error 'Dial missing arguments' unless @to and @from
    super type: 'offer'
    attributes:
      to: @to
      from: @from

module.exports = Offer
