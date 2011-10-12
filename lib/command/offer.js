(function() {
  var Offer, Presence;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Presence = require('../presence');
  Offer = (function() {
    __extends(Offer, Presence);
    function Offer(_arg) {
      this.to = _arg.to, this.from = _arg.from;
      if (!(this.to && this.from)) {
        throw new Error('Dial missing arguments');
      }
      Offer.__super__.constructor.call(this, {
        type: 'offer',
        attributes: {
          to: this.to,
          from: this.from
        }
      });
    }
    return Offer;
  })();
  module.exports = Offer;
}).call(this);
