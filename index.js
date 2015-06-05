var fs = require('fs');
var archiver = require('archiver');
var http = require('http');
var querystring = require('querystring');

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

function authorize(aidbox){
  console.log('Authorization', aidbox.name)
  var p = q()

  var auth = 'Basic ' + new Buffer(aidbox.client_id 
      + ':' + aidbox.client_secret).toString('base64');
  var body  = {
    'grant_type': aidbox.grant_type,
    'scope': aidbox.ups
  };
  var postData = querystring.stringify(body);
  var header = {
    'Authorization': auth,
    'Content-Type': 'application/x-www-form-urlencoded',
    'Content-Length': postData.length
  };
  var req = http.request( {
    method: 'POST',
    hostname: aidbox.server,
    port : aidbox.port,
    path: '/oauth/token',
    headers: header
  });
  req.on('response', function (response) {
    var str_data = "";
    var data = {};

    response.on('data', function (chunk) {
      str_data += chunk;
    });

    response.on('end', function(){
      // Check response status
      if(response.statusCode == 403){
        console.error('Access deny');
        return p;
      }
      
      data = JSON.parse(str_data);
      for(var i in data){
        aidbox[i] = data[i];
      }
      p.resolve(aidbox)
    })
  });

  req.on('error', function(e) {
    console.log('problem with request: ' + e.message);
    return p;
  });

  req.write(postData);
  req.end();

  return p;
}

function publish(aidbox){
  console.log('Publishing application', aidbox.name)
    console.log(aidbox);
  var p = q()
  var stats = fs.statSync("./dist.tar.gz")
  var rest = require('restler');
  var url = 'http://'+aidbox.server+':8080/deploy';
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
  .then(authorize)
  .then(publish)
}
