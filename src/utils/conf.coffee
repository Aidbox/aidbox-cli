# Aidox CLI congiguration
fs   = require 'fs'
cli  = require 'cli'
path = require('path')
home = process.env[if process.platform == 'win32' then 'USERPROFILE' else 'HOME']

conf =
  server: process.env.AIDBOX_SERVER || "https://aidbox.io"
  root: 'root'

# Get home dir
homedir=(username)->
  if username then path.resolve(path.dirname(home), username) else home

test=()->
  6

confFileName = homedir()+'/.aidbox.json'

# Read conf file
readConfFile=(fileName, conf)->
  if fs.existsSync fileName
    data = JSON.parse(fs.readFileSync fileName, 'utf8')
    for k,v of data
      conf[k] = v

# Save conf data
writeConfFile=(data)->
  fs.writeFile confFileName, JSON.stringify(data), (err)->
    cli.error "Cannot save" if err

# Delete conf file
deleteConfFile=()->
  fs.unlink confFileName, ()->
    cli.ok "All session data are removed"

# Get conf data
readConfFile confFileName, conf

module.exports =
  conf: conf
  save: writeConfFile
  clear: deleteConfFile
  homedir: homedir
  test: test
