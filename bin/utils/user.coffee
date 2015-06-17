# USERS crud
cli    = require 'cli'
rest   = require 'restler'
read   = require 'read'
config = require './conf'

conf = config.conf

# Users list
userList=(cb)->
  rest.get conf.box.host+"/users", {
    username: 'root'
    password: conf.box.secret
  }
  .on 'complete', (data, response)->
    if response.statusCode == 403
      cli.error 'Access deny'
      return
    if data instanceof Error
      cli.error data.message
      cli.error data
    else
      cb data
  .on 'error', (e)->
    cli.error 'Problem with request: ' + e.message

# Rest user create
userRestCreate=(email, password)->
  rest.post conf.box.host+'/users',
      username: 'root'
      password: conf.box.secret
      data: JSON.stringify( email: email, password: password)
      headers: {'Content-Type': 'application/json'}
    .on 'complete', (data, response)->
      if response.statusCode == 403
        cli.error 'Access deny'
        return
      if data instanceof Error
        cli.error data.message
        cli.error data
      else
        if data.errors
          cli.error "Cannot create user [#{email}] in box [#{conf.box.id}]"
          cli.error data.errors.email
        else
          cli.ok "User [#{email}] created successfully in box [#{conf.box.id}]"
    .on 'error', (e)->
      cli.error 'Problem with request: ' + e.message

# Create new user
userNew=(args)->
  cli.info "Create new user in box [#{conf.box.id}]"
  if args[1]
    params = args[1].split(":")
    userRestCreate params[0], params[1]
  else
    read {prompt: "Email: " }, (err, email)->
      if err
        return cli.error err
      read {prompt: "Password: " }, (err, password)->
        if err
          return cli.error err
        userRestCreate email, password
  
# Show help
userHelp=()->
  console.log """
  user list                -- Show users list in current box
  user help                -- Show help
  user new                 -- Create user via wizard
  user new email:password  -- Create user one line
  """

user=(args, options)->
  switch args[0]
    when 'new'  then userNew(args)
    when 'help' then userHelp()
    when 'list'
      cli.info "Users list in box [#{conf.box.id}]"
      userList console.log
    else userHelp()

module.exports = user

