assert = require "assert"

describe 'Test Conf util', ()->
  conf = require './../lib/utils/conf'
  it '#Test read and save config data', ()->
    test =
      server: process.env.AIDBOX_SERVER || "https://aidbox.io" # Def important
      root: 'root'                                             # Def important
      email: 'test@email.com'
      pass: 'password'
      box:{ id: 'testbox', secret: 'secret'}
    conf.save(test)
    _t = conf.conf()
    assert.deepEqual(test, _t )
      
