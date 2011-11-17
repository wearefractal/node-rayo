call = (queue, id, args) ->
  if queue[id]
    callback = queue[id]
    callback? args?
    delete queue[id]


module.exports = call

