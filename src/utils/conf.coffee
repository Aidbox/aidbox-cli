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

confFileName = homedir()+'/.aidbox.json'

# Read conf file
readConfFile=(fileName)->
  if fs.existsSync fileName
    JSON.parse(fs.readFileSync fileName, 'utf8')
  else
    conf

# Save conf data
writeConfFile=(data)->
  fs.writeFileSync confFileName, JSON.stringify(data)

# Delete conf file
deleteConfFile=()->
  fs.unlink confFileName, ()->
    cli.ok "All session data are removed"

# Get conf data
readConf=()-> readConfFile confFileName

module.exports =
  conf: readConf
  save: writeConfFile
  clear: deleteConfFile
  homedir: homedir
