(function() {
  var Message, static, util, xmpp;
  xmpp = require('node-xmpp');
  static = require('./static');
  util = require('./util');
  Message = (function() {
    function Message(_arg) {
      var _base, _base2, _base3, _ref, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
      this.rootName = _arg.rootName, this.rootAttributes = _arg.rootAttributes, this.childName = _arg.childName, this.childAttributes = _arg.childAttributes, this.sipHeaders = _arg.sipHeaders, this.children = _arg.children;
      if (!this.rootName) {
        throw new Error('Missing rootName');
      }
      if (!this.childName) {
        throw new Error('Missing childName');
      }
      if ((_ref = this.childAttributes) == null) {
        this.childAttributes = {};
      }
      if ((_ref2 = this.rootAttributes) == null) {
        this.rootAttributes = {};
      }
      if ((_ref3 = this.sipHeaders) == null) {
        this.sipHeaders = {};
      }
      if ((_ref4 = this.children) == null) {
        this.children = [];
      }
      if (this.rootName === 'iq') {
        if ((_ref5 = (_base = this.rootAttributes).type) == null) {
          _base.type = 'set';
        }
      }
      if ((_ref6 = (_base2 = this.rootAttributes).id) == null) {
        _base2.id = util.getRandomId();
      }
      if ((_ref7 = (_base3 = this.childAttributes).xmlns) == null) {
        _base3.xmlns = static.xmlns;
      }
    }
    Message.prototype.getId = function() {
      return this.rootAttributes.id;
    };
    Message.prototype.getElement = function(server, jid) {
      var child, el, head, sub, _i, _len, _ref;
      if (this.rootAttributes.to.indexOf('$callserver' > 0)) {
        this.rootAttributes.to = this.rootAttributes.to.replace('$callserver', server);
      }
      if (this.rootAttributes.from === ("" + jid.user + "@" + jid.domain) || "$localuser") {
        this.rootAttributes.from = "" + jid.user + "@" + jid.domain + "/" + jid.resource;
      }
      el = new xmpp.Element(this.rootName, this.rootAttributes);
      sub = el.c(this.childName, this.childAttributes);
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        sub.c(child);
      }
      for (head in this.sipHeaders) {
        sub.c('header', {
          name: head,
          value: this.sipHeaders[head]
        });
      }
      return el;
    };
    return Message;
  })();
  module.exports = Message;
}).call(this);
