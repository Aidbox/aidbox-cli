oauth  = require './utils/oauth'
box    = require './utils/box'
user   = require './utils/user'
deploy = require './utils/deploy'

cli   = require 'cli'

exports.run = ()->
  cli.parse null, ['v', 'login', 'logout', 'box', 'user', 'deploy', 'test']
  cli.main (args, options)->
    switch cli.command
      when 'login'  then oauth.login(args)
      when 'logout' then oauth.logout()
      when 'box'    then box(args, options)
      when 'user'   then user(args, options)
      when 'deploy' then deploy(args, options)
      when 'test'   then test()
      when 'v'      then cli.ok "v0.4.1"
