class MessageQueue
  constructor: ->
    @queue = []

  push: (id, message) ->
    @queue[id] = message

  find: (message) ->
    id = message.getId()
    if id in @queue
      callback = @queue[id]
      callback? message
      delete callback

