(function() {
  module.exports = {
    Connection: require('./connection'),
    Static: require('./static'),
    Accept: require('./command/accept'),
    Answer: require('./command/answer'),
    Hangup: require('./command/hangup'),
    Mute: require('./command/mute'),
    Unmute: require('./command/unmute'),
    Hold: require('./command/hold'),
    Unhold: require('./command/unhold'),
    Redirect: require('./command/redirect'),
    Reject: require('./command/reject'),
    Dial: require('./command/dial'),
    DTMF: require('./command/dtmf')
  };
}).call(this);
