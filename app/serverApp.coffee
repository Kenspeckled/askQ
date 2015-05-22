# Add absolute paths for all require statements to './app'
# include server controllers as separate path
process.env.NODE_PATH =  __dirname+':'+__dirname + '/controllers/server'
require('module').Module._initPaths()

global._scriptContext = 'server' # needed for routing
global.React = require 'react'
global._ = require 'lodash'
global._utilities = require '../frameworkCore/utilities.coffee'
global.BaseClass = require '../frameworkCore/Base.coffee'
global.ObjectOrientedRecord = require '../frameworkCore/ObjectOrientedRecord.coffee'
global.ActionHandler = require '../frameworkCore/ActionHandler.coffee'

#require('productDataInit.coffee')()

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
