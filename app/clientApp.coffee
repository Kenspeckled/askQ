global._scriptContext = 'client' # needed for routing
global.React = require 'react'
global._ = require 'lodash'
global._utilities = require '../frameworkCore/utilities.coffee'
global.BaseClass = require '../frameworkCore/Base.coffee'
global.ObjectOrientedRecord = require '../frameworkCore/ObjectOrientedRecord.coffee'
global.ActionHandler = require '../frameworkCore/ActionHandler.coffee'
ClientRouter = require '../frameworkCore/clientRouter/ClientRouter.coffee'
DataCache = require '../frameworkCore/DataCache.coffee'
global.dataCache = new DataCache()
dataCache.setCacheFromContext(document)
routes = require 'routes.coffee'
routes(ClientRouter, 'client') # Initalise routes
require('listenerRegistery.coffee')()
