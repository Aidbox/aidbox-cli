# BOX crud
cli    = require 'cli'
rest   = require 'restler'
config = require './conf'

conf = config.conf

# Get all boxes
boxList=(cb)->
  rest.get conf.server+"/boxes", {
    username: conf.username
    password: conf.password
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

# Get current box name
boxCurrent=()->
  if conf.box && conf.secret
    cli.ok "You current box [#{conf.box}]"
  else
    cli.info "No current box"

# Create new box
boxNew=(name)->
  console.log conf
  cli.info "Create new box [#{name}]"
  rest.post conf.server+"/boxes", {
    username: conf.username
    password: conf.password
    data: JSON.stringify({ id: name })
    headers: {'Content-Type': 'application/json'}
  }
  .on 'complete', (data, response)->
    if response.statusCode == 403
      cli.error 'Access deny'
      return
    if data instanceof Error
      cli.error data.message
      cli.error data
    else
      if data.status == 'error'
        cli.error data.error
      else
        cli.ok "Box [#{name}] created"
        conf.box = name
        conf.secret = data[0].secret
        config.save conf
  .on 'error', (e)->
    cli.error 'Problem with request: ' + e.message

# Search box by name in boxes list
searchBox=(boxes, key, val)->
  for v,i in boxes
    if v[key] == val
      return i
  -1

# Checkout to box
boxSwitch=(name)->
  if !name
    return cli.error "No box selected"
  
  boxList (boxes)->
    i = searchBox(boxes, 'id', name)
    if i != -1
      conf.box = boxes[i].id
      conf.secret = boxes[i].secret
      config.save(conf)
      cli.ok "Current box switch to box [#{name}]"
    else
      cli.error "Box [#{name}] not exist"

box=(args, options)->
  if args.length
    switch args[0]
      # Create new Box
      when 'new' then boxNew(args[1])
      when 'switch' then boxSwitch(args[1])

  else
    if options.list
      # Show all boxes
      cli.info "Boxes list"
      boxList console.log
    else
      # Show current box name
      boxCurrent()

module.exports = box
