# Add absolute paths for all require statements to './app'
# include server controllers as separate path
process.env.NODE_PATH =  __dirname+':'+__dirname + '/controllers/server'
require('module').Module._initPaths()
require 'globals.coffee'

global._scriptContext = 'server' # needed for routing
express = require 'express'
server = express()

server.use express.static('public')
server.set('views', __dirname + '/views')
server.set('view engine', 'jade')


require('routes.coffee')(server, 'server') # Initalise get routes

server = server.listen 8000, ->
  host = server.address().address
  port = server.address().port
  console.log "App listening at http://%s:%s", host, port
