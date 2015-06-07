# Add absolute paths for all require statements to './app'
# include server controllers as separate path
process.env.NODE_PATH =  __dirname+':'+__dirname + '/controllers/server'
require('module').Module._initPaths()
require 'globals.coffee'
bodyParser = require 'body-parser'

global._scriptContext = 'server' # needed for routing
express = require 'express'
server = express()
io = require('socket.io')()

# attach the socket.io instance to the request object
server.use (req, res, next) ->
  req.io = io;
  next()

server.use express.static('public')
server.use bodyParser.urlencoded(extended: true)
server.set('views', __dirname + '/views')
server.set('view engine', 'jade')

require('routes.coffee')(server, 'server') # Initalise get routes

server = server.listen 8000, 'localhost', ->
  host = server.address().address
  port = server.address().port
  console.log "App listening at http://%s:%s", host, port

io.listen(server)

