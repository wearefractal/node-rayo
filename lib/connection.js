(function() {
  var Connection, EventEmitter, Message, rayo, static, xmpp;
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
  Message = require('./message');
  EventEmitter = require('events').EventEmitter;
  Connection = (function() {
    __extends(Connection, EventEmitter);
    function Connection(_arg) {
      var _ref, _ref2, _ref3, _ref4;
      this.host = _arg.host, this.port = _arg.port, this.jabberId = _arg.jabberId, this.jabberPass = _arg.jabberPass, this.verbose = _arg.verbose;
      if ((_ref = this.host) == null) {
        this.host = static["default"].host;
      }
      if (this.host.contains(':')) {
        _ref2 = this.host.split(':'), this.host = _ref2[0], this.port = _ref2[1];
      }
      if ((_ref3 = this.port) == null) {
        this.port = static["default"].port;
      }
      if ((_ref4 = this.verbose) == null) {
        this.verbose = false;
      }
    }
    Connection.prototype.connect = function() {
      var matchQueue;
      this.callbacks = {};
      this.conn = new xmpp.Client({
        jid: this.jabberId,
        password: this.jabberPass,
        host: this.server,
        port: this.port
      });
      this.conn.on('online', __bind(function() {
        this.connected = true;
        this.conn.on('stanza', __bind(function(stanza) {
          return this.handleStanza(stanza);
        }, this));
        this.emit('connected');
        return this.conn.send(new xmpp.Element('presence').c('show').t('chat').up().c('status').t('I am online!'));
      }, this));
      this.conn.on('offline', __bind(function() {
        this.connected = false;
        return this.emit('disconnected');
      }, this));
      this.conn.on('authFail', __bind(function(err) {
        return this.emit('error', err);
      }, this));
      this.conn.on('error', __bind(function(err) {
        return this.emit('error', err);
      }, this));
      matchQueue = __bind(function(cmd) {
        var cb, id;
        id = cmd.getId();
        if (id != null) {
          cb = this.callbacks[id];
          cb(null, cmd);
          return delete cb;
        }
      }, this);
      return this.on('message', matchQueue);
    };
    Connection.prototype.disconnect = function() {
      return this.conn.end();
    };
    Connection.prototype.send = function(command, cb) {
      var el;
      el = command.getElement(this.host, this.conn.jid);
      if (this.verbose) {
        console.log('Sending outbound message: ' + el.toString());
      }
      if (typeof cb === 'function') {
        this.callbacks[command.getId()] = cb;
      }
      return this.conn.send(el);
    };
    /*
        Handlers for incoming messages/events
      */
    Connection.prototype.handleStanza = function(stanza) {
      var message;
      this.emit('stanza', stanza);
      if (this.verbose) {
        console.log('Receiving inbound message: ' + stanza);
      }
      if (stanza.attrs.type === 'error') {
        return this.handleError(stanza);
      }
      this.emit(stanza.name, stanza);
      message = this.getMessage(stanza);
      this.emit(message.childName, message);
      return this.emit('message', message);
    };
    Connection.prototype.handleError = function(stanza) {
      var cb, child, err, msg;
      cb = this.callbacks[stanza.attrs.id];
      if (Object.isFunction(cb)) {
        if (stanza.children) {
          err = ((function() {
            var _i, _len, _ref, _results;
            _ref = stanza.children;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              child = _ref[_i];
              if (child.name === 'error') {
                _results.push(child);
              }
            }
            return _results;
          })())[0];
          if (err) {
            msg = ((function() {
              var _i, _len, _ref, _results;
              _ref = err.children;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                child = _ref[_i];
                if (child.name === 'text') {
                  _results.push(child);
                }
              }
              return _results;
            })())[0].children[0];
            return cb(new Error("Type: " + err.attrs.type + ", Message: " + msg));
          } else if (stanza.children && stanza.children[0].children) {
            return cb(new Error(stanza.children[0].children[0].name));
          }
        } else {
          return cb(new Error("Generic Error! Stanza: " + stanza));
        }
      } else {
        return console.log('UNHANDLED ERROR! - ' + stanza);
      }
    };
    /*
        Utilities
      */
    Connection.prototype.getMessage = function(stanza) {
      var child, childs, head, mess, x, _i, _j, _len, _len2, _ref, _ref2;
      child = stanza.children[0];
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
        mess = new Message({
          rootName: stanza.name,
          rootAttributes: stanza.attrs,
          childName: child.name,
          childAttributes: child.attrs,
          sipHeaders: head,
          children: childs
        });
      } else {
        mess = new Message({
          rootName: stanza.name,
          rootAttributes: stanza.attrs,
          childName: stanza.type
        });
      }
      return mess;
    };
    return Connection;
  })();
  module.exports = Connection;
}).call(this);
