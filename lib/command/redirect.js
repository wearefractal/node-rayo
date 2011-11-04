(function() {
  var Message, Redirect;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Message = require('../message');
  Redirect = (function() {
    __extends(Redirect, Message);
    function Redirect(_arg) {
      this.offer = _arg.offer, this.to = _arg.to;
      if (!this.offer) {
        throw new Error('Missing "offer" parameter');
      }
      if (!this.to) {
        throw new Error('Missing "to" parameter');
      }
      Redirect.__super__.constructor.call(this, {
        rootName: 'iq',
        childName: 'redirect',
        rootAttributes: {
          id: this.offer.rootAttributes.id,
          to: this.offer.rootAttributes.from,
          from: this.offer.rootAttributes.to
        },
        childAttributes: {
          to: this.to
        }
      });
    }
    return Redirect;
  })();
  module.exports = Redirect;
}).call(this);
