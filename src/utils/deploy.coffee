# Deploy app
cli      = require 'cli'
fs       = require 'fs'
rest     = require 'restler'
archiver = require 'archiver'
config   = require './conf'

conf = config.conf

dist = 'dist'
distArchive = './aidboxdist.tar.gz'

#compress app
compress=(cb)->
  cli.info "Compress you app..."

  output = fs.createWriteStream(distArchive)
  output.on 'close', cb
  
  archive = archiver 'tar', {gzip: true, gzipOptions: { level: 1 }}
  archive
    .on 'error', (err)->
      cli.error "Erro when compress: #{err}"
    .pipe output

  archive
    .bulk [{expand: true, cwd: dist, src: ['**']}]
    .finalize()

publish=()->
  cli.info "Publish app..."

  fileName = distArchive
  stats = fs.statSync fileName
  rest.post conf.box.host+'/deploy',
    multipart: true
    username: 'root'
    password: conf.box.secret
    data:
      file: rest.file fileName, null, stats.size, null, 'application/x-gzip'
  .on 'complete', (data, response)->
    if response.statusCode == 403
      cli.error 'Access deny'
      return
    if data instanceof Error
      cli.error data.message
      cli.error data
    else
      cli.ok data.message+" in box [#{conf.box.id}]"
      fs.unlink distArchive, ()->
        cli.ok "Tmp files removed"


deploy=(args, options)->
  dist = args[0] || dist
  compress publish

module.exports = deploy
