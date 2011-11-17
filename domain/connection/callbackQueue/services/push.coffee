_ = require 'slice'
isFunction = _.load 'util.services.isFunction'

push = (queue, id, callback) ->
  if isFunction callback
    queue[id] = callback
  else
    throw new Error message: "Invalid parameter, must add a function as a callback"


module.exports = push

