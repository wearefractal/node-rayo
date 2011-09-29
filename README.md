**node-rayo is a NodeJS client for the popular [Rayo](https://github.com/rayo/) protocol**


## Installation
    
To install node-rayo, use [npm](http://github.com/isaacs/npm):

    $ npm install rayo

## Usage

    RayoConnection = require("rayo").Connection
    conn = new RayoConnection "cool-rayo-server.whatevz.net", "coolguy85", "secretpass69"
    
    conn.on "connected", (isRayo) ->
      console.log "Connected to " + conn.server
      console.warn "Server does not support the Rayo protocol" unless isRayo
    
    conn.on "disconnected", (cause) ->
      console.log "Disconnected! Cause: " + cause.message
      console.log "Attempting to reconnect..."
      conn.connect()
    
    conn.on "connectionFailed", (error) -> 
      console.error "Connection to server failed! Reason: " + error.message
    
    conn.on "incomingCall", (call) -> 
      console.log "Getting a call from " + call.from
      call.answer()
    
    conn.connect()
    
    conn.send {}, (response, err) ->
      console.log "Response XML: " + response
      console.error err.message  if err
    
    conn.call "tommyboi92", (call) ->
      call.hold()
      call.unhold()
      call.hangup()

## Examples

You can view further examples in the [example folder.](https://github.com/wearefractal/node-rayo/tree/master/examples)
