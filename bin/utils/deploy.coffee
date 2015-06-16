# Deploy app
cli      = require 'cli'
fs       = require 'fs'
rest     = require 'restler'
archiver = require 'archiver'
config   = require './conf'

conf = config.conf

#compress app
compress=(cb)->
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
      cli.ok data.message

deploy=()->
  compress publish

###
  var stats = fs.statSync("./dist.tar.gz")

  rest.post(aidbox.server+'/deploy', {
    multipart: true,
    data: {
      app: aidbox.name,
      access_token: aidbox.access_token,
      file: rest.file('./dist.tar.gz', null, stats.size, null, 'application/x-gzip')
    }
  }).on('complete', function(result, response) {
    if(response.statusCode == 403){
      console.error('Access deny');
      return p;
    }
    if (result instanceof Error) {
      console.log('Error:', result.message);
      console.log(result)
    this.retry(5000);
    } else {
      console.log("Published:", result);
    }
  });
  return p;

###
module.exports = deploy
