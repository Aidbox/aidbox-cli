# Deploy app
cli      = require 'cli'
fs       = require 'fs'
rest     = require 'restler'
archiver = require 'archiver'
config   = require './conf'

conf = config.conf

#compress app
compress=(cb)->
  cli.info "Compress you app..."

  output = fs.createWriteStream('./dist.tar.gz')
  output.on 'close', cb
  
  archive = archiver 'tar', {gzip: true, gzipOptions: { level: 1 }}
  archive
    .on 'error', (err)->
      cli.error "Erro when compress: #{err}"
    .pipe output

  archive
    .bulk [{expand: true, cwd: 'dist', src: ['**']}]
    .finalize()

publish=()->
  cli.info "Publish app..."

  fileName = './dist.tar.gz'
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

deploy=()->
  compress publish

module.exports = deploy
