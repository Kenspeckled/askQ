# Add absolute paths for all require statements to './app'
# include server controllers as separate path
process.env.NODE_PATH =  __dirname+':'+__dirname + '/server'
require('module').Module._initPaths()
require 'globals.coffee'
global.ObjectOrientedRecord = require 'oomph/lib/models/ServerObject'
