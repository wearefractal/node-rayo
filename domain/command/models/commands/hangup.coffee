class Hangup
  constructor: ({@id, @to, @from}) ->
    throw new Error 'Missing "id and from and to" parameter' unless @id and @from and @to

module.exports = Hangup

