class Reject
  constructor: ({@id, @from, @to, @reason = 'decline'}) ->
    throw new Error 'Missing "id and from and to" parameter' unless @id and @from and @to

module.exports = Reject

