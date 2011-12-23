(function() {
  var conn, log, rayo, rayoConfig;

  rayo = require('../rayo');

  rayoConfig = require('./config');

  log = require('node-log');

  log.setName('rayo-test');

  conn = new rayo.Connection(rayoConfig);

  conn.on('connected', function() {
    var call, call2;
    log.info('Connected!');
    call = conn.create('dial', {
      to: 'sip:contracontra@sip2sip.info',
      from: 'sip:rayo@test.net'
    });
    call2 = conn.create('dial', {
      to: 'sip:contracontra2@sip2sip.info',
      from: 'sip:rayo@test.net'
    });
    return conn.send(call, function(cmd) {
      call.listen(cmd.id);
      call.callid = cmd.id;
      return call.on('answered', function() {
        log.info("Call 1 answered!");
        return conn.send(call2, function(cmd) {
          call2.listen(cmd.id);
          call2.callid = cmd.id;
          return call2.on('answered', function() {
            var join;
            log.info("Call 2 answered!");
            join = conn.create('join', {
              callid: call.callid,
              'call-id': call2.callid,
              direction: 'duplex',
              media: 'bridge'
            });
            return conn.send(join, function(cmd) {
              return console.log("WAT: " + (JSON.stringify(cmd)));
            });
          });
        });
      });
    });
  });

  conn.on('disconnected', function() {
    return log.info('Connection closed');
  });

  conn.on('error', function(err) {
    return log.error(err.message);
  });

  conn.connect();

}).call(this);
