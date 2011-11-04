(function() {
  var Accept, Message;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Message = require('../message');
  Accept = (function() {
    __extends(Accept, Message);
    function Accept(_arg) {
      this.offer = _arg.offer;
      if (!this.offer) {
        throw new Error('Missing "offer" parameter');
      }
      Accept.__super__.constructor.call(this, {
        rootName: 'iq',
        childName: 'accept',
        rootAttributes: {
          id: this.offer.rootAttributes.id,
          to: this.offer.rootAttributes.from,
          from: this.offer.rootAttributes.to
        }
      });
    }
    return Accept;
  })();
  module.exports = Accept;
}).call(this);
