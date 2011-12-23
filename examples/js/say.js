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
      var accept, answer, say;
      log.info("Incoming call...");
      accept = conn.create('accept', {
        callid: cmd.callid
      });
      answer = conn.create('answer', {
        callid: cmd.callid
      });
      say = conn.create('say', {
        callid: cmd.callid,
        xmlns: 'urn:xmpp:tropo:say:1',
        voice: 'allison',
        audio: [
          {
            src: 'http://youarefloating.com/beats/Favella%20Dwella/bossa%20tek.mp3'
          }, {
            src: 'http://youarefloating.com/beats/Soul%20Proprietor/i%20wish%20render%201.mp3'
          }
        ]
      });
      say.on('complete', function(cmd) {
        return console.log(cmd);
      });
      conn.send(accept);
      conn.send(answer);
      log.info("Answered call");
      return conn.send(say, function(cmd) {
        return say.listen(cmd.id);
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
