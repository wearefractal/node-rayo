(function() {
  var Answer, Message;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Message = require('../message');
  Answer = (function() {
    __extends(Answer, Message);
    function Answer(_arg) {
      this.offer = _arg.offer;
      Answer.__super__.constructor.call(this, {
        rootName: 'iq',
        childName: 'answer',
        rootAttributes: {
          id: this.offer.rootAttributes.id,
          to: this.offer.rootAttributes.from,
          from: this.offer.rootAttributes.to
        }
      });
    }
    return Answer;
  })();
  module.exports = Answer;
}).call(this);
