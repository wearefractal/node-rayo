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
      var _ref;
      this.id = _arg.id, this.to = _arg.to, this.from = _arg.from;
      if ((_ref = this.id) == null) {
        this.id = '1234' + Math.floor(Math.random() * 101);
      }
      Dial.__super__.constructor.call(this, {
        type: 'dial',
        message: {
          id: this.id,
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
