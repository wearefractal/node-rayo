(function() {
  var Call, EventRouter;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  EventRouter = require('eventrouter');
  Call = (function() {
    __extends(Call, EventRouter);
    function Call(connection, id, to, from) {
      this.connection = connection;
      this.id = id;
      this.to = to;
      this.from = from;
      Call.__super__.constructor.call(this, this.connection);
      this.route('*', __bind(function(res) {
        return res.childAttributes.id === this.id;
      }, this));
    }
    return Call;
  })();
  module.exports = Call;
}).call(this);
