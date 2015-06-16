# Aidox CLI congiguration
fs = require 'fs'
cli = require 'cli'

conf = {
  server: "http://aidbox.hs"
}
confFileName = '.aidbox.json'

# Read conf file
readConfFile=(fileName, conf)->
  if fs.existsSync fileName
    data = JSON.parse(fs.readFileSync fileName, 'utf8')
    for  k,v of data
      conf[k] = v

# Save conf data
writeConfFile=(data)->
  fs.writeFile confFileName, JSON.stringify(data), (err)->
    if err
      cli.error "Cannot save"

# Delete conf file
deleteConfFile=()->
  fs.unlink confFileName, ()->
    cli.ok "All session data are removed"

# Get conf data
readConfFile confFileName, conf

module.exports = {
  conf : conf
  save : writeConfFile
  clear: deleteConfFile
}
