_ = require 'slice'
Dial = _.load 'command.models.commands.Dial'

dial =
  new rayo.Dial
    to: 'sip:codexrex@sip2sip.info'
    from: 'sip:test@whadupdoe.net'


module.exports = dial

