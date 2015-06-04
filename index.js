var fs = require('fs');
var archiver = require('archiver');

function q(){
  var listeners = [];

  var promise = {
    then: function(cb){
      var p = q()
      var fn = function(){
        var res = cb.apply(null, arguments)
        if(res && res.then){
          res.then(p.resolve)
        }
        return p;
      }
      listeners.push(fn);
      return p;
    },
    resolve: function(p){
      listeners.forEach(function(x){
        x(p);
      });
    }
  };
  return promise;
}

function config(){
  console.log('Reading manifest aidbox.json')
  var p = q()
  fs.readFile('./aidbox.json', 'utf8', function (err,data) {
    if (err) { return console.log(err); }
    aidbox = JSON.parse(data)
    p.resolve(aidbox);
  });
  return p;
}

function compress(aidbox){
  console.log('Archiving application')
  var p = q()
  var output = fs.createWriteStream('./dist.tar.gz');
  var archive = archiver('tar', { gzip: true, gzipOptions: { level: 1 } });

  output.on('close', function() {
    p.resolve(aidbox)
  });

  archive.on('error', function(err) { throw err; });
  archive.pipe(output);
  archive.bulk([{expand: true, cwd: 'dist', src: ['**']}]).finalize();
  return p;
}

function publish(aidbox){
  console.log('Publishing application', aidbox.name)
  var p = q()
  var stats = fs.statSync("./dist.tar.gz")
  var rest = require('restler');
  var url = aidbox.server || 'http://fhirplace.health-samurai.io/api/app';
  rest.post(url, {
    multipart: true,
    data: {
      app: aidbox.name,
      file: rest.file('./dist.tar.gz', null, stats.size, null, 'application/x-gzip')
    }
  }).on('complete', function(result) {
    if (result instanceof Error) {
      console.log('Error:', result.message);
      console.log(result)
    this.retry(5000);
    } else {
      console.log("Published:", result);
    }
  });
  return p;
}

module.exports = function(){
  config()
  .then(compress)
  .then(publish)
}
