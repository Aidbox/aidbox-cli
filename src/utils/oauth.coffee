# Login to dashboard
cli    = require 'cli'
rest   = require 'restler'
read   = require 'read'
config = require './conf'

login=()->
  conf = config.conf
  if (conf.username && conf.password)
    cli.info "You are logged in"
  else
    read {prompt: "Login: " }, (err, username)->
      read {prompt: "Password: ", silent: true }, (err, password)->
        rest.get conf.server+'/boxes',
            username: username
            password: password
            data:
              grant_type: 'client_credentials'
              scope: 'ups'
          .on 'complete', (data, response)->
            if response.statusCode == 403
              cli.error 'Access deny'
              return
            if data instanceof Error
              cli.error data.message
              cli.error data
            else
              cli.ok "Auth success"
              conf.username = username
              conf.password = password
              config.save conf
          .on 'error', (e)->
            cli.error 'Problem with request: ' + e.message

# Logout
logout=()->
  config.clear()
  cli.ok "You are now logged out"

module.exports = {
  login : login
  logout : logout
}
