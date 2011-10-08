(function() {
  var Connection, EventEmitter, static, xmpp;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  xmpp = require('node-xmpp');
  static = require('./static');
  EventEmitter = require('events').EventEmitter;
  Connection = (function() {
    __extends(Connection, EventEmitter);
    function Connection(_arg) {
      var _ref, _ref2, _ref3;
      this.host = _arg.host, this.jabberId = _arg.jabberId, this.jabberPass = _arg.jabberPass;
      if ((_ref = this.host) == null) {
        this.host = static["default"].host;
      }
      if (this.host.contains(':')) {
        _ref2 = this.host.split(':'), this.host = _ref2[0], this.port = _ref2[1];
      }
      if ((_ref3 = this.port) == null) {
        this.port = static["default"].port;
      }
    }
    Connection.prototype.connect = function() {
      this.queue = [];
      this.conn = new xmpp.Client({
        jid: this.jabberId,
        password: this.jabberPass,
        host: this.server,
        port: this.port
      });
      this.conn.on('online', __bind(function() {
        this.conn.on('stanza', __bind(function(stanza) {
          return this.handleStanza(stanza);
        }, this));
        return this.emit('connected');
      }, this));
      this.conn.on('authFail', __bind(function(err) {
        return this.emit('error', err);
      }, this));
      return this.conn.on('error', __bind(function(err) {
        return this.emit('error', err);
      }, this));
    };
    Connection.prototype.disconnect = function() {
      return this.conn.end();
    };
    Connection.prototype.send = function(command, cb) {
      this.conn.send(command.getElement());
      return this.queue[command.getId()] = __bind(function(err, res) {
        if (res.attrs.id) {
          delete this.queue[res.attrs.id];
          return cb(err, res);
        }
      }, this);
    };
    /*
        Handlers for incoming messages/events
      */
    Connection.prototype.handleStanza = function(stanza) {
      console.log(stanza);
      if (!stanza) {
        return;
      }
      if (stanza.from.domain !== this.conn.server) {
        throw new Error("Message from unknown domain " + stanza.from.domain);
      }
      if (stanza.attrs.type === 'error') {
        return this.handleError(stanza);
      }
      switch (stanza.name) {
        case 'presence':
          return this.handlePresence(stanza);
        case 'iq':
          return this.handleIq(stanza);
        default:
          throw new Error("Unknown Stanza type. Stanza: " + stanza);
      }
    };
    Connection.prototype.handleIq = function(iq) {
      var cb;
      switch (iq.attrs.type) {
        case 'error':
          return this.handleError(iq);
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
      if (presence.attrs.type === 'error') {
        return this.handleError(presence);
      }
      cb = this.getListener(presence);
      return type = presence.getChild();
    };
    Connection.prototype.handleError = function(stanza) {
      var cb, _ref;
      cb = this.getListener(stanza);
      return cb(new Error((_ref = stanza.getChild().value) != null ? _ref : "Generic Stanza Error. Stanza: " + stanza));
    };
    /*
        Utilities
      */
    Connection.prototype.isRayo = function(stanza) {
      return stanza.getNS() === static.xmlns;
    };
    Connection.prototype.getListener = function(stanza) {
      var callback;
      callback = this.queue[stanza.attrs.id];
      if (callback != null) {
        return callback;
      } else {
        return function() {};
      }
    };
    return Connection;
  })();
  module.exports = Connection;
}).call(this);
