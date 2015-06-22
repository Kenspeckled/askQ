landingPageController = require 'controllers/landingPage.coffee'
questionController = require 'controllers/question.coffee'
questionBoardController = require 'controllers/questionBoard.coffee'

routes = (router) ->
  router.get '/', landingPageController.index
  router.get '/:url', questionController.index

  if _scriptContext.isClient
    router.start()

  else if _scriptContext.isServer
    router.get '/api/question-board', questionBoardController.apiShow
    router.get '/api/question-board/:id', questionBoardController.apiShow
    router.post '/api/question-board', questionBoardController.apiCreate

    router.get '/api/questions', questionController.apiIndex
    router.post '/api/question', questionController.apiCreate
    router.get '/api/question', questionController.apiShow
    router.get '/api/question/:id', questionController.apiShow
    router.post '/api/question/:id/vote/:direction', questionController.apiVote

module.exports = routes

