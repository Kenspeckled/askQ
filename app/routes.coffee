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
    router.get '/api/question', questionController.apiShow
    router.get '/api/questions', questionController.apiIndex
    router.post '/api/question', questionController.apiCreate
    router.post '/api/question/:id/vote/:direction', questionController.apiVote

    router.get '/api/question-board', questionBoardController.apiShow
    router.post '/api/question-board', questionBoardController.apiCreate

module.exports = routes

