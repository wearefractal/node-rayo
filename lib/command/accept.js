(function() {
  var Accept, iq;
  iq = require('../iq');
  Accept = (function() {
    function Accept() {
      return new iq({
        type: 'accept'
      });
    }
    return Accept;
  })();
}).call(this);
