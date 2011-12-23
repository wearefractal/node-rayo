(function() {
  var conn, log, rayo, rayoConfig;

  rayo = require('../rayo');

  rayoConfig = require('./config');

  log = require('node-log');

  log.setName('rayo-test');

  conn = new rayo.Connection(rayoConfig);

  conn.on('connected', function() {
    var dial;
    log.info('Connected!');
    dial = conn.create('dial', {
      to: 'sip:contracontra@sip2sip.info',
      from: 'sip:rayo@test.net'
    });
    dial.on('ringing', function(cmd) {
      return log.info("Call ringing...");
    });
    dial.on('answered', function(cmd) {
      return log.info("Call answered!");
    });
    dial.on('end', function(cmd) {
      return log.info("Call ended");
    });
    return conn.send(dial, function(cmd) {
      return dial.listen(cmd.id);
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
