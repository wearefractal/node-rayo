_ = require 'slice'

module.exports =

  Connection: _.load 'connection.models.Connection'

  # Commands

  Accept:   _.load 'commands.models.Accept'
  Answer:   _.load 'commands.models.Answer'
  Hangup:   _.load 'commands.models.Hangup'
  Mute:     _.load 'commands.models.Mute'
  Unmute:   _.load 'commands.models.Unmute'
  Hold:     _.load 'commands.models.Hold'
  Unhold:   _.load 'commands.models.Unhold'
  Redirect: _.load 'commands.models.Redirect'
  Reject:   _.load 'commands.models.Reject'

  Dial:     _.load 'commands.models.Dial'
  DTMF:     _.load 'commands.models.DTMF'

