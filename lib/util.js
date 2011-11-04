(function() {
  module.exports = {
    getRandomId: function() {
      var rand;
      rand = function() {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
      };
      return "" + (rand()) + "-" + (rand()) + "-" + (rand()) + "-" + (rand()) + "-" + (rand());
    }
  };
}).call(this);
