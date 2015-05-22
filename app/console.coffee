# Add absolute paths for all require statements to './app'
# include server controllers as separate path
process.env.NODE_PATH =  __dirname+':'+__dirname + '/controllers/server'
require('module').Module._initPaths()

global._ = require 'lodash'
global.React = require 'react'
global._utilities = require '../frameworkCore/utilities.coffee'
global.BaseClass = require '../frameworkCore/Base.coffee'
global.ObjectOrientedRecord = require '../frameworkCore/ObjectOrientedRecord.coffee'
global.ActionHandler = require '../frameworkCore/ActionHandler.coffee'
