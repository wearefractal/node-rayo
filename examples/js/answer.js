(function() {
  var conn, log, rayo, rayoConfig;

  rayo = require('../rayo');

  rayoConfig = require('./config');

  log = require('node-log');

  log.setName('rayo-test');

  conn = new rayo.Connection(rayoConfig);

  conn.on('connected', function() {
    log.info('Connected!');
    return conn.on('offer', function(cmd) {
      var accept, answer;
      log.info("Incoming call...");
      accept = conn.create('accept', {
        callid: cmd.callid
      });
      answer = conn.create('answer', {
        callid: cmd.callid
      });
      conn.send(accept);
      conn.send(answer);
      return log.info("Answered call!");
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
