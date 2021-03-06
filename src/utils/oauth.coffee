# Login to dashboard
cli    = require 'cli'
rest   = require './rest'
read   = require 'read'
config = require './conf'
helper = require './helper'
conf   = config.conf()

auth = (username, password)->
  rest.get '/boxes',
      username: username
      password: password
      data:
        grant_type: 'client_credentials'
        scope: 'ups'
    .on 'complete', (data, response)->
      helper.catchError data, response, (data)->
        cli.ok "Auth success"
        conf.username = username
        conf.password = password
        config.save conf
    .on 'error', helper.errHandler


login=([username, password])->
  if (conf.username && conf.password)
    cli.info "You are logged in #{conf.username}"
  else
    if username && password
      auth(username, password)
    else
      read {prompt: "Login: " }, (err, username)->
        return cli.error err if err
        read {prompt: "Password: ", silent: true }, (err, password)->
          return cli.error err if err
          auth(username, password)

# Logout
logout=()->
  config.clear()
  cli.ok "You are now logged out"

module.exports =
  login: login
  logout: logout
