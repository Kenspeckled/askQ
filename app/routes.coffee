#homeController = require 'home.coffee'
sessionController = require 'session'

landingPageController = require 'landingPage.coffee'
questionController = require 'question.coffee'
#homeController = require 'home.coffee'
sessionController = require 'session'

routes = (router) ->
  if !(_scriptContext == 'server' or _scriptContext == 'client')
    throw new Error('_scriptContext not defined properly')

  #router.get '/', homeController.index
  # router.get '/', homeController.index
  router.get '/', landingPageController.index
  #router.get '/:url', questionController.index
  #router.get '/', homeController.index
  # router.get '/', homeController.index

  if _scriptContext == 'client'
    router.start()


  else if _scriptContext == 'server'
    router.get '/:sessionUrl', sessionController.session
    router.post '/api/add-question', sessionController.addQuestion
    router.post '/api/vote', sessionController.vote
    router.post '/api/flag', sessionController.flag
    router.get '/api/all-questions', sessionController.index

module.exports = routes

