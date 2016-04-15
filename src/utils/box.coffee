# BOX crud
cli    = require 'cli'
rest   = require 'restler'
config = require './conf'
helper = require './helper'

r  = require './rest'

conf = config.conf()

# Get all boxes
boxList=(cb)->
  rest.get conf.server+"/boxes",
    username: conf.username
    password: conf.password
  .on 'complete', (data, response)->
    helper.catchError data, response, cb
  .on 'error', helper.errHandler

# Get current box name
boxCurrent=()->
  if conf.box && conf.box.id && conf.box.secret
    cli.ok "You current box [#{conf.box.id}]"
  else
    cli.info "No current box"
    cli.info "For switch to box, try: $ aidbox box use box_name"
    cli.info "Or create new box: $ aidbox box new box_name"

# Create new box
boxNew=(name)->
  cli.info "Create new box [#{name}]"
  rest.post conf.server+"/boxes",
    username: conf.username
    password: conf.password
    data: JSON.stringify({ id: name })
    headers: {'Content-Type': 'application/json'}
  .on 'complete', (data, response)->
    helper.catchError data, response, (data)->
      if data.status == 'error'
        cli.error data.error
      else
        cli.ok "Box [#{name}] created"
        cli.ok "Current box switch to [#{name}]"
        conf.box = data
        config.save conf
  .on 'error', helper.errHandler

# Switch to box
boxSwitch=(name)->
  return cli.error "No box selected" if !name

  r.get "/boxes/#{name}"
  .on 'success', (data, response)->
    conf.box = data
    config.save(conf)
    cli.ok "Current box switch to [#{name}]"
  .on 'fail', ()->
    cli.error "Cannot connect to box [#{name}]"
  .on 'error', helper.errHandler

# Show help data
boxHelp=()->
  console.log """
    box                 -- Display current box
    box help            -- Show help
    box new <boxname>   -- Create new box with name <boxname>
    box list            -- Show all available boxes
    box use <boxname>   -- Switch current box to <boxname>
    box destroy         -- Destroy current box [!not ready!]
  """

box=(args, options)->
  if args.length
    switch args[0]
      # Create new Box
      when 'new' then boxNew(args[1])
      # Show help data
      when 'help' then boxHelp()
      # Show all boxes
      when 'list'
        cli.info "Boxes list"
        boxList helper.boxTable
      # Switch to box
      when 'use' then boxSwitch(args[1])
      # help by default
      else boxHelp()

  else
    # Show current box id
    boxCurrent()

module.exports = box
