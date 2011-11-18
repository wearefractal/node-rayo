class Hold extends Message
  constructor: ({@id, @from, @to}) ->
    throw new Error 'Missing "id and from and to" parameter' unless @id and @from and @to

module.exports = Hold

