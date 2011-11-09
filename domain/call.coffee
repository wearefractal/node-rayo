EventRouter = require 'eventrouter'

class Call extends EventRouter
  constructor: (@connection, @id, @to, @from) ->
    super @connection
    @route '*', (res) => res.childAttributes.id is @id
    
module.exports = Call
