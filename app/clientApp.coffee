global._scriptContext = isClient: true # needed for routing
require 'globals.coffee'
ClientRouter = require 'clientRouter/ClientRouter.coffee'
DataCache = require 'DataCache.coffee'
global.dataCache = new DataCache()
global.ObjectOrientedRecord = require 'oomph/lib/models/ClientObject'
routes = require 'routes.coffee'
routes(ClientRouter, 'client') # Initalise routes
