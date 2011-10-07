(function() {
  var Command, ltx, xmpp;
  xmpp = require('node-xmpp');
  ltx = xmpp.ltx;
  Command = (function() {
    function Command(_arg) {
      _arg;
    }
    Command.prototype.getElement = function() {};
    return Command;
  })();
}).call(this);
