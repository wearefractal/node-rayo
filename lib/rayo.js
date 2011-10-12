(function() {
  require('protege');
  module.exports = {
    Connection: require('./connection'),
    Static: require('./static'),
    Accept: require('./command/accept'),
    Answer: require('./command/answer')
  };
}).call(this);
