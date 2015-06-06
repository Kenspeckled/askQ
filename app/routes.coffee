landingPageController = require 'landingPage.coffee'
questionController = require 'question.coffee'

routes = (router) ->
  if !(_scriptContext == 'server' or _scriptContext == 'client')
    throw new Error('_scriptContext not defined properly')

  router.get '/', landingPageController.index
  router.get '/:url', questionController.index

  if _scriptContext == 'client'
    router.start()

  else if _scriptContext == 'server'
    router.get '/api/question/index', questionController.apiIndex
    router.get '/api/question/:id', questionController.apiShow
    router.post '/api/question/new', questionController.apiCreate
    router.post '/api/question-board/new', questionController.apiCreateBoard
    # router.post '/api/vote', sessionController.vote
    # router.post '/api/flag', sessionController.flag
    # router.get '/api/all-questions', sessionController.indexJSON

module.exports = routes

