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
      var accept, answer, ask;
      log.info("Incoming call...");
      accept = conn.create('accept', {
        callid: cmd.callid
      });
      answer = conn.create('answer', {
        callid: cmd.callid
      });
      ask = conn.create('ask', {
        callid: cmd.callid,
        xmlns: 'urn:xmpp:tropo:ask:1',
        bargein: 'true',
        'min-confidence': '0.3',
        mode: 'speech|dtmf|any',
        recognizer: 'en-US',
        terminator: '#',
        timeout: '12000',
        prompt: {
          voice: 'allison',
          text: 'Please enter your four digit pin'
        },
        choices: {
          'content-type': 'application/grammar+voxeo',
          text: '[4 DIGITS]'
        }
      });
      ask.on('complete', function(cmd) {
        var result;
        if (cmd.success) {
          result = cmd.success.interpretation;
          return console.log("User input was " + result);
        }
      });
      conn.send(accept);
      conn.send(answer);
      log.info("Answered call");
      return conn.send(ask, function(cmd) {
        return ask.listen(cmd.id);
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
