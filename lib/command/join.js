(function() {
  var Join, Message;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Message = require('../message');
  Join = (function() {
    __extends(Join, Message);
    function Join(_arg) {
      var _ref, _ref2;
      this.hoster = _arg.hoster, this.joinee = _arg.joinee, this.direction = _arg.direction, this.media = _arg.media;
      if (!this.hoster) {
        throw new Error('Missing "hoster" parameter');
      }
      if (!this.joinee) {
        throw new Error('Missing "joinee" parameter');
      }
      if ((_ref = this.direction) == null) {
        this.direction = 'duplex';
      }
      if ((_ref2 = this.media) == null) {
        this.media = 'bridge';
      }
      Join.__super__.constructor.call(this, {
        rootName: 'iq',
        childName: 'join',
        rootAttributes: {
          id: this.joinee.getId(),
          to: this.joinee.getTo(),
          from: this.joinee.getFrom()
        },
        childAttributes: {
          "call-id": this.hoster.getId(),
          direction: this.direction,
          media: this.media
        }
      });
    }
    return Join;
  })();
  module.exports = Join;
}).call(this);
