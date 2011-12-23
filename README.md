node-rayo is a NodeJS client for the popular [Rayo](https://github.com/rayo/) protocol

## Dependencies

  **node-rayo** depends on the [jab](https://github.com/wearefractal/jab) xmpp library which has some native dependencies for XML processing.  Install with:

  ```
  sudo apt-get install libexpat1 libexpat1-dev 
  sudo apt-get install libicu-dev 
  ```

## Installation
    
To install and use node-rayo, use [npm](http://github.com/isaacs/npm):

  $ npm install node-rayo

## Usage

Include node-rayo:

`var rayo = require('node-rayo');`

To get started, create a connection with `rayo.Connection()`:

  ```
  conn = new rayo.Connection({
    host: 'prism.host.com',
    jabberId: 'youruser@jabber.org',
    jabberPass: 'pass',
    debug: off,
    ping: true   
  });
  ```

You can then use `conn.create()` to create a Rayo command:

  ```
  dial = conn.create('dial', {
    to: 'sip:someuser@sip2sip.info',
    from: 'sip:rayo@test.net'
  });

  ```

Once your command is created, you can listen to events specific to that command:

  ```
  dial.on('ringing', function(cmd) {
    return log.info("Call ringing...");
  });
  dial.on('answered', function(cmd) {
    return log.info("Call answered!");
  });
  ```

And then send that command (note dial, component and mixer commands require `command.listen(cmd.id);` to wire up event handlers):
  
  ```
  return conn.send(dial, function(cmd) {
    return dial.listen(cmd.id);
  });
  ```

Finally, connect!

  ```
  conn.connect();
  ```

## Examples

You can view more complete examples in both CoffeeScript and JavaScript in the [examples folder.](https://github.com/rayo/node-rayo/tree/master/examples)
