(function() {
  var Iq, static, xmpp;
  xmpp = require('node-xmpp');
  static = require('./static');
  Iq = (function() {
    function Iq(_arg) {
      var _base, _base2, _ref, _ref2, _ref3, _ref4, _ref5, _ref6;
      this.type = _arg.type, this.message = _arg.message, this.headers = _arg.headers, this.attributes = _arg.attributes, this.children = _arg.children;
      if (!this.type) {
        throw new Error('Type required for Iq!');
      }
      if ((_ref = this.attributes) == null) {
        this.attributes = {};
      }
      if ((_ref2 = this.message) == null) {
        this.message = {};
      }
      if ((_ref3 = this.headers) == null) {
        this.headers = {};
      }
      if ((_ref4 = this.children) == null) {
        this.children = {};
      }
      if ((_ref5 = (_base = this.message).type) == null) {
        _base.type = 'set';
      }
      if ((_ref6 = (_base2 = this.attributes).xmlns) == null) {
        _base2.xmlns = static.xmlns;
      }
    }
    Iq.prototype.getId = function() {
      return this.message.id;
    };
    Iq.prototype.getElement = function(jid) {
      var child, el, head, sub, _i, _len, _ref;
      if (this.message.from === ("" + jid.user + "@" + jid.domain)) {
        this.message.from += "/" + jid.resource;
      }
      el = new xmpp.Element('iq', this.message);
      sub = el.c(this.type, this.attributes);
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        sub.c(child);
      }
      for (head in this.headers) {
        sub.c('header', {
          name: head,
          value: this.headers[head]
        });
      }
      return el;
    };
    return Iq;
  })();
  module.exports = Iq;
}).call(this);
