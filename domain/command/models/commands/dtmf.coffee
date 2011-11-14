Message = require '../message'

class DTMF extends Message
  constructor: ({@callId, @tones, @from}) ->
    @from ?= '$localuser'
    throw new Error 'callId and tones required for DTMF command' unless @callId and @tones
    super 
      rootName: 'iq'
      childName: 'dtmf'
      rootAttributes:
        id: @callId
        from: @from
        to: @callId + '@$callserver'
        
      childAttributes:
        tones: @tones

module.exports = DTMF
