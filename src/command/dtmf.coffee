Iq = require '../iq'

class DTMF extends Iq
  constructor: ({@callId, @tones, @from}) ->
    @from ?= '$localuser'
    throw new Error 'callId and tones required for DTMF command' unless @callId and @tones
    super type: 'dtmf'
    message:
      from: @from
      to: @callId + '@$callserver'
      
    attributes:
      tones: @tones

module.exports = DTMF
