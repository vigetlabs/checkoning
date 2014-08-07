connect     = require 'connect'
serveStatic = require 'serve-static'
open        = require 'open'

connect().use(serveStatic('output')).listen(8080)
open('http://localhost:8080/index.html');
