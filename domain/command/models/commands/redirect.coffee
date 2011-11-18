class Redirect
  constructor: ({@id, @from, @to, @destination}) ->
    throw new Error 'Missing "id and from and to" parameter' unless @id and @from and @to

module.exports = Redirect

