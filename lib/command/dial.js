(function() {
  var Dial, Iq;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Iq = require('../iq');
  Dial = (function() {
    __extends(Dial, Iq);
    function Dial(_arg) {
      this.to = _arg.to, this.from = _arg.from;
      Dial.__super__.constructor.call(this, {
        type: 'dial',
        message: {
          id: '1234',
          to: '$callserver',
          from: '$localuser'
        },
        attributes: {
          to: this.to,
          from: this.from
        }
      });
    }
    return Dial;
  })();
  module.exports = Dial;
}).call(this);
