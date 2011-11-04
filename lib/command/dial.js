(function() {
  var Dial, Message;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Message = require('../message');
  Dial = (function() {
    __extends(Dial, Message);
    function Dial(_arg) {
      this.to = _arg.to, this.from = _arg.from;
      Dial.__super__.constructor.call(this, {
        rootName: 'iq',
        childName: 'dial',
        rootAttributes: {
          to: '$callserver',
          from: '$localuser'
        },
        childAttributes: {
          to: this.to,
          from: this.from
        }
      });
    }
    return Dial;
  })();
  module.exports = Dial;
}).call(this);
