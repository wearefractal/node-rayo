(function() {
  var Iq, static, xmpp;
  xmpp = require('node-xmpp');
  static = require('./static');
  Iq = (function() {
    function Iq(_arg) {
      var _base, _ref, _ref2;
      this.type = _arg.type, this.message = _arg.message, this.headers = _arg.headers, this.attributes = _arg.attributes, this.child = _arg.child;
      if (!this.type) {
        throw new Error('Type required for Iq!');
      }
      if ((_ref = this.attributes) == null) {
        this.attributes = {};
      }
      if ((_ref2 = (_base = this.attributes).xmlns) == null) {
        _base.xmlns = static.xmlns;
      }
    }
    Iq.prototype.getId = function() {
      return this.id;
    };
    Iq.prototype.getElement = function() {
      var el, head, sub, _i, _len, _ref;
      el = new xmpp.Element('iq', this.message);
      sub = el.c(this.type, this.attributes);
      if (this.child != null) {
        sub.c(this.child);
      }
      if (this.headers != null) {
        _ref = this.headers;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          head = _ref[_i];
          sub.c('header', head);
        }
      }
      return el;
    };
    return Iq;
  })();
}).call(this);
