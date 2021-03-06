// Generated by CoffeeScript 1.9.3
(function() {
  var assert;

  assert = require("assert");

  describe('Test Conf util', function() {
    var conf;
    conf = require('./../lib/utils/conf');
    return it('#Test read and save config data', function() {
      var _t, test;
      test = {
        server: process.env.AIDBOX_SERVER || "https://aidbox.io",
        root: 'root',
        email: 'test@email.com',
        pass: 'password',
        box: {
          id: 'testbox',
          secret: 'secret'
        }
      };
      conf.save(test);
      _t = conf.conf();
      return assert.deepEqual(test, _t);
    });
  });

}).call(this);
