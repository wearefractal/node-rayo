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
      var accept, redirect;
      log.info("Incoming call...");
      accept = conn.create('accept', {
        callid: cmd.callid
      });
      redirect = conn.create('reject', {
        callid: cmd.callid,
        redirect: {
          to: 'tel:+14802515171'
        },
        header: [
          {
            "x-skill": "agent"
          }, {
            "x-customer-id": "8877"
          }
        ]
      });
      conn.send(accept);
      conn.send(redirect);
      return log.info("Redirected call");
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
