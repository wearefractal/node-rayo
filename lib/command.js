(function() {
  var Command, ltx, xmpp;
  xmpp = require('node-xmpp');
  ltx = xmpp.ltx;
  Command = (function() {
    function Command(_arg) {
      var _ref, _ref2, _ref3;
      this.type = _arg.type, this.id = _arg.id, this.headers = _arg.headers, this.attributes = _arg.attributes, this.child = _arg.child;
      if (!this.type) {
        throw new Error('Type required for Command!');
      }
      if (!this.id) {
        throw new Error('Id required for Command!');
      }
      if ((_ref = this.attributes) == null) {
        this.attributes = {};
      }
      if ((_ref2 = this.child) == null) {
        this.child = '';
      }
      if ((_ref3 = this.headers) == null) {
        this.headers = [];
      }
    }
    Command.prototype.getId = function() {
      return this.id;
    };
    Command.prototype.getElement = function() {};
    return Command;
  })();
}).call(this);
