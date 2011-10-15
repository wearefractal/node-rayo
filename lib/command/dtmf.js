(function() {
  var DTMF, Message;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Message = require('../message');
  DTMF = (function() {
    __extends(DTMF, Message);
    function DTMF(_arg) {
      var _ref;
      this.callId = _arg.callId, this.tones = _arg.tones, this.from = _arg.from;
      if ((_ref = this.from) == null) {
        this.from = '$localuser';
      }
      if (!(this.callId && this.tones)) {
        throw new Error('callId and tones required for DTMF command');
      }
      DTMF.__super__.constructor.call(this, {
        rootName: 'iq',
        childName: 'dtmf',
        rootAttributes: {
          id: this.callId,
          from: this.from,
          to: this.callId + '@$callserver'
        },
        childAttributes: {
          tones: this.tones
        }
      });
    }
    return DTMF;
  })();
  module.exports = DTMF;
}).call(this);
