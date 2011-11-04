(function() {
  var Message, Mute;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Message = require('../message');
  Mute = (function() {
    __extends(Mute, Message);
    function Mute(_arg) {
      this.offer = _arg.offer;
      if (!this.offer) {
        throw new Error('Missing "offer" parameter');
      }
      Mute.__super__.constructor.call(this, {
        rootName: 'iq',
        childName: 'mute',
        rootAttributes: {
          id: this.offer.rootAttributes.id,
          to: this.offer.rootAttributes.from,
          from: this.offer.rootAttributes.to
        }
      });
    }
    return Mute;
  })();
  module.exports = Mute;
}).call(this);
