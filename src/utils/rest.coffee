restler = require 'restler'
config  = require './conf'
helper  = require './helper'

conf = config.conf()

xhr = (method, [uri, params, host])->
  if conf.box
    at = query: access_token: conf.box.access_token
  else
    at = {}
  host = host || conf.server
  restler.request "#{host}#{uri}",
    helper.merge
      method: method
      username: conf.username
      password: conf.password
      headers: {'Content-Type': 'application/json'}
      parser: restler.parsers.auto
    , params, at

module.exports =
  get: ()->
    xhr "get", arguments
  post: ()->
    xhr "post", arguments
  file: restler.file
