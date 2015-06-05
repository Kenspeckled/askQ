require 'globals.coffee'
global._scriptContext = 'client' # needed for routing
ClientRouter = require '../frameworkCore/clientRouter/ClientRouter.coffee'
DataCache = require '../frameworkCore/DataCache.coffee'
global.dataCache = new DataCache()
routes = require 'routes.coffee'
routes(ClientRouter, 'client') # Initalise routes
require('listenerRegistery.coffee')()
