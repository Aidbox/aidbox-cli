restler = require 'restler'
config  = require './conf'

conf = config.conf()
module.exports =
  get: (uri)->
    restler.get "#{conf.server}#{uri}",
      username: conf.username
      password: conf.password

