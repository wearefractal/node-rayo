(function() {
  var Dial, iq;
  iq = require('../iq');
  Dial = (function() {
    function Dial(_arg) {
      this.to = _arg.to, this.from = _arg.from;
      if (!(this.to && this.from)) {
        throw new Error('DialCommand missing arguments');
      }
      return new iq({
        type: 'dial',
        attributes: {
          to: this.to,
          from: this.from
        }
      });
    }
    return Dial;
  })();
}).call(this);
