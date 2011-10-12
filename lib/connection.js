(function() {
  var Connection, EventEmitter, Iq, Presence, rayo, static, xmpp;
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
  rayo = require('./rayo');
  Presence = require('./presence');
  Iq = require('./iq');
  EventEmitter = require('events').EventEmitter;
  Connection = (function() {
    __extends(Connection, EventEmitter);
    function Connection(_arg) {
      var _ref, _ref2, _ref3;
      this.host = _arg.host, this.port = _arg.port, this.jabberId = _arg.jabberId, this.jabberPass = _arg.jabberPass;
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
        this.emit('connected');
        return this.conn.send(new xmpp.Element('presence').c('show').t('chat').up().c('status').t('I am online!'));
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
      var el;
      el = command.getElement(this.conn.jid);
      this.conn.send(el);
      if (Object.isFunction(cb)) {
        return this.queue[command.getId()] = __bind(function(err, res) {
          if (err) {
            return cb(err);
          }
          if (res.attrs.id) {
            delete this.queue[res.attrs.id];
            return cb(err, res);
          }
        }, this);
      }
    };
    /*
        Handlers for incoming messages/events
      */
    Connection.prototype.handleStanza = function(stanza) {
      if (stanza.attrs.type === 'error') {
        return this.handleError(stanza);
      }
      switch (stanza.name) {
        case 'presence':
          return this.handlePresence(stanza);
        case 'iq':
          return this.handleIq(stanza);
        default:
          return console.log("Unknown Stanza type. Stanza: " + stanza);
      }
    };
    Connection.prototype.handleIq = function(iq) {
      var cb, child, childs, head, icky, x, _i, _j, _len, _len2, _ref, _ref2;
      this.emit('iq', iq);
      switch (iq.attrs.type) {
        case 'error':
          return this.handleError(iq);
        case 'result':
          cb = this.getListener(iq);
          child = iq.children[0];
          if (child) {
            head = {};
            childs = {};
            _ref = child.children;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              x = _ref[_i];
              if (x.name === 'header') {
                head[x.attrs.name] = x.attrs.value;
              }
            }
            _ref2 = child.children;
            for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
              x = _ref2[_j];
              if (x.name !== 'header') {
                childs[x.name] = x.attrs;
              }
            }
            icky = new Iq({
              type: child.type || iq.type,
              message: iq.attrs,
              attributes: child.attrs,
              headers: head,
              children: childs
            });
          } else {
            icky = new Iq({
              type: iq.type,
              message: iq.attrs
            });
          }
          this.emit(icky.type, icky);
          return cb(null, iq);
        default:
          return console.log('Unknown Iq - ' + iq);
      }
    };
    Connection.prototype.handlePresence = function(presence) {
      var cb, child, childs, command, head, x, _i, _j, _len, _len2, _ref, _ref2;
      this.emit('presence', presence);
      child = presence.children[0];
      if (this.isRayo(child)) {
        cb = this.getListener(presence);
        head = {};
        childs = {};
        _ref = child.children;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          x = _ref[_i];
          if (x.name === 'header') {
            head[x.attrs.name] = x.attrs.value;
          }
        }
        _ref2 = child.children;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          x = _ref2[_j];
          if (x.name !== 'header') {
            childs[x.name] = x.attrs;
          }
        }
        command = new Presence({
          type: child.name,
          message: presence.attrs,
          attributes: child.attrs,
          headers: head,
          children: childs
        });
        this.emit(child.name, command);
        return cb(null, command);
      }
    };
    Connection.prototype.handleError = function(stanza) {
      var cb, _ref, _ref2;
      cb = this.getListener(stanza);
      return cb(new Error(((_ref = stanza.children[0]) != null ? (_ref2 = _ref.children[0]) != null ? _ref2.name : void 0 : void 0) || ("Stanza Error! Stanza: " + stanza)));
    };
    /*
        Utilities
      */
    Connection.prototype.isRayo = function(stanza) {
      return (stanza != null ? stanza.getNS() : void 0) === static.xmlns;
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
