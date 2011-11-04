(function() {
  var Message, Unmute;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Message = require('../message');
  Unmute = (function() {
    __extends(Unmute, Message);
    function Unmute(_arg) {
      this.offer = _arg.offer;
      if (!this.offer) {
        throw new Error('Missing "offer" parameter');
      }
      Unmute.__super__.constructor.call(this, {
        rootName: 'iq',
        childName: 'unmute',
        rootAttributes: {
          id: this.offer.rootAttributes.id,
          to: this.offer.rootAttributes.from,
          from: this.offer.rootAttributes.to
        }
      });
    }
    return Unmute;
  })();
  module.exports = Unmute;
}).call(this);
