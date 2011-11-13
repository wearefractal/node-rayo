isFunction = (func) ->

  if func? and typeof func is 'function'
    return true
  else
    return false

module.exports = isFunction

