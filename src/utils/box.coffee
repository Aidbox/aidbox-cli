# BOX crud
cli    = require 'cli'
rest   = require './rest'
helper = require './helper'
config = require './conf'
conf   = config.conf()

# Get all boxes
boxList=(cb)->
  rest.get "/boxes"
  .on 'success', cb
  .on 'fail',  helper.errHandler
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
  rest.post "/boxes",
    data: JSON.stringify({ id: name })
  .on 'success', (data, response)->
    cli.ok "Box [#{name}] created"
    cli.ok "Current box switch to [#{name}]"
    conf.box = data
    config.save conf
  .on 'fail', (data)->
    cli.error data.message
  .on 'error', helper.errHandler

# Switch to box
boxSwitch=(name)->
  return cli.error "No box selected" if !name

  rest.get "/boxes/#{name}"
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
