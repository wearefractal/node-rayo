(function() {
  var Accept, Iq;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Iq = require('../iq');
  Accept = (function() {
    __extends(Accept, Iq);
    function Accept(_arg) {
      this.offer = _arg.offer;
      Accept.__super__.constructor.call(this, {
        type: 'accept',
        message: {
          id: this.offer.message.id,
          to: this.offer.message.from,
          from: this.offer.message.to
        }
      });
    }
    return Accept;
  })();
  module.exports = Accept;
}).call(this);
