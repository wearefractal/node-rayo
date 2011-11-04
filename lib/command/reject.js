(function() {
  var Message, Reject;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Message = require('../message');
  Reject = (function() {
    __extends(Reject, Message);
    function Reject(_arg) {
      var _ref;
      this.offer = _arg.offer, this.reason = _arg.reason;
      if (!this.offer) {
        throw new Error('Missing "offer" parameter');
      }
      if ((_ref = this.reason) == null) {
        this.reason = 'decline';
      }
      Reject.__super__.constructor.call(this, {
        rootName: 'iq',
        childName: 'reject',
        rootAttributes: {
          id: this.offer.rootAttributes.id,
          to: this.offer.rootAttributes.from,
          from: this.offer.rootAttributes.to
        },
        children: [this.reason]
      });
    }
    return Reject;
  })();
  module.exports = Reject;
}).call(this);
