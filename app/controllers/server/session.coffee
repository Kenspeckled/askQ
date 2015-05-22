session = require 'models/extendedModels/session'

sessionController =

  session: (req, res) ->
    url = req.params.sessionUrl
    session.createSession(url)

  addQuestion: (req, res) ->
    url = req.body.sessionUrl
    question = req.body.question
    session.addQuestion(url, question)

  vote: (req, res) ->
    questionNumber = req.body.questionNumber
    condition = req.body.condition
    session.vote(questionNumber, condition)

  flag: (req, res) ->
    questionNumber = req.body.questionNumber
    session.flag(questionNumber)

  index: (req, res) ->
    url = req.params.sessionUrl
    session.getQuestions(url)



module.exports = sessionController
