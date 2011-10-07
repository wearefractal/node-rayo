(function() {
  var Connection, EventEmitter, xmpp;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  xmpp = require('node-xmpp');
  EventEmitter = require('events').EventEmitter;
  Connection = (function() {
    __extends(Connection, EventEmitter);
    function Connection(server, jabberId, jabberPass) {
      var _ref, _ref2;
      this.server = server;
      this.jabberId = jabberId;
      this.jabberPass = jabberPass;
      if ((_ref = this.server) == null) {
        this.server = 'call.rayo.net';
      }
      if (this.server.contains(':')) {
        _ref2 = this.server.split(':'), this.server = _ref2[0], this.port = _ref2[1];
      } else {
        this.port = 5222;
      }
    }
    Connection.prototype.connect = function() {
      this.queue = [];
      this.conn = xmpp.Client({
        jid: this.jabberId,
        password: this.jabberPass,
        host: this.server,
        port: this.port
      });
      this.conn.on('online', function() {
        this.conn.on('stanza', this.handleStanza);
        return this.emit('connected');
      });
      this.conn.on('authFail', function(err) {
        return this.emit('failure', err);
      });
      return this.conn.on('error', function(err) {
        return this.emit('error', err);
      });
    };
    Connection.prototype.disconnect = function() {
      return this.conn.end();
    };
    Connection.prototype.send = function(command, cb) {
      this.conn.send(command.getElement());
      return this.queue[command.getId()] = function(err, res) {
        if (res.attrs.id) {
          delete this.queue[res.attrs.id];
        }
        return cb(err, res);
      };
    };
    Connection.prototype.handleStanza = function(stanza) {
      console.log(stanza);
      if (stanza.from.domain !== this.server) {
        throw new Error("Message from unknown domain " + stanza.from.domain);
      }
      if (stanza.attrs.type === 'error') {
        return handleError(stanza);
      }
      switch (stanza.name) {
        case 'presence':
          return handlePresence(stanza);
        case 'iq':
          return handleIq(stanza);
        default:
          throw new Error("Unknown Stanza type. Stanza: " + stanza);
      }
    };
    Connection.prototype.handleIq = function(iq) {
      var cb;
      switch (stanza.attrs.type) {
        case 'error':
          return handleError(iq);
        case 'success':
          cb = this.getListener(iq);
          return cb(null, stanza.getChild());
        default:
          return console.log('Unknown Iq - ' + iq);
      }
    };
    Connection.prototype.handlePresence = function(presence) {
      var cb, type;
      if (!this.isRayo(presence)) {
        throw new Error("Stanza is not Rayo protocol. Stanza: " + presence);
      }
      if (stanza.attrs.type === 'error') {
        return handleError(presence);
      }
      cb = this.getListener(presence);
      return type = presence.getChild();
    };
    Connection.prototype.handleError = function(stanza) {
      var cb;
      cb = this.getListener(stanza);
      return cb(new Error(stanza.getChild().getText() || ("Generic Stanza Error. Stanza: " + stanza)));
    };
    Connection.prototype.isRayo = function(stanza) {
      return stanza.getNS() === 'urn:xmpp:rayo:1';
    };
    Connection.prototype.getListener = function(stanza) {
      var callback;
      if (!stanza.attrs.id) {
        throw new Error("Missing stanza.attrs.id. Stanza: " + stanza);
      }
      callback = this.queue[stanza.attrs.id];
      if (callback != null) {
        return callback;
      } else {
        return function() {};
      }
    };
    return Connection;
  })();
}).call(this);
