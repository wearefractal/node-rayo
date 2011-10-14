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
    Iq.prototype.getElement = function(server, jid) {
      var child, el, head, sub;
      if (this.message.to.contains('$callserver')) {
        this.message.to = this.message.to.replace('$callserver', server);
      }
      if (this.message.from === ("" + jid.user + "@" + jid.domain) || "$localuser") {
        this.message.from = "" + jid.user + "@" + jid.domain + "/" + jid.resource;
      }
      el = new xmpp.Element('iq', this.message);
      sub = el.c(this.type, this.attributes);
      for (child in this.children) {
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
