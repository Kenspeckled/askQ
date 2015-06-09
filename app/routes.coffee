landingPageController = require 'landingPage.coffee'
questionController = require 'question.coffee'
questionBoardController = require 'questionBoard.coffee'

routes = (router) ->
  if !(_scriptContext == 'server' or _scriptContext == 'client')
    throw new Error('_scriptContext not defined properly')

  router.get '/', landingPageController.index
  router.get '/:url', questionController.index

  if _scriptContext == 'client'
    router.start()

  else if _scriptContext == 'server'
    router.get '/api/question/index', questionController.apiIndex
    router.get '/api/question/show', questionController.apiShow
    router.post '/api/question/new', questionController.apiCreate
    router.post '/api/question/:id/vote/:direction', questionController.apiVote

    router.get '/api/question-board/show', questionBoardController.apiShow
    router.post '/api/question-board/new', questionBoardController.apiCreate

module.exports = routes

