assert = require "assert"

describe 'Conf util', ()->
  conf   = require './../lib/utils/conf'
  describe 'test', ()->
    it 'Shoul return 5', ()->
      assert.equal(5, conf.test())
