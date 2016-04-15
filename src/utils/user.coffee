# USERS crud
cli    = require 'cli'
rest   = require './rest'
read   = require 'read'
config = require './conf'
helper = require './helper'

conf = config.conf()

# Users list
userList=(cb)->
  rest.get "/users", {}, conf.box.host
  .on 'complete', (data, response)->
    helper.catchError data, response, cb
  .on 'error', helper.errHandler

# Rest user create
userRestCreate=(email, password)->
  rest.post '/users',
    data: JSON.stringify( email: email, password: password)
    ,conf.box.host
  .on 'complete', (data, response)->
    helper.catchError data, response, (data)->
      if data.errors
        cli.error "Cannot create user [#{email}] in box [#{conf.box.id}]"
        cli.error data.errors.email
      else
        cli.ok "User [#{email}] created successfully in box [#{conf.box.id}]"
  .on 'error', helper.errHandler

# Create new user
userNew=(args)->
  cli.info "Create new user in box [#{conf.box.id}]"
  if args[1]
    params = args[1].split(":")
    userRestCreate params[0], params[1]
  else
    read {prompt: "Email: " }, (err, email)->
      return cli.error err if err
      read {prompt: "Password: " }, (err, password)->
        return cli.error err if err
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
  unless conf.box
    cli.info "No current box selected"
    cli.info "For switch to box, try: $ aidbox box use box_name"
    cli.info "Or create new box: $ aidbox box new box_name"
    return

  switch args[0]
    when 'new'  then userNew(args)
    when 'help' then userHelp()
    when 'list'
      cli.info "Users list in box [#{conf.box.id}]"
      userList helper.userTable
    else userHelp()

module.exports = user

