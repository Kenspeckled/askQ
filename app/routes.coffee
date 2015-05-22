questionController = require 'question.coffee'
routes = (router) ->
  if !(_scriptContext == 'server' or _scriptContext == 'client')
    throw new Error('_scriptContext not defined properly')

  router.get '/:url', questionController.index

  if _scriptContext == 'client'
    router.start() 

  #else if _scriptContext == 'server'
    #router.post '/blah', (req, res) ->
    #  res.send 'hello'

module.exports = routes

