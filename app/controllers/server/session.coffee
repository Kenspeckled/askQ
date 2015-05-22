session = require 'models/extendedModels/session'
QuestionIndex = require 'views/components/questions/index.coffee'

sessionController =

  session: (req, res) ->
    url = req.path.replace('/', '')
    session.createSession(url)
    props = {}
    try
      element = React.createElement(QuestionIndex, props)
      html = React.renderToString element
    catch error
      html = error if process.env.SHOW_QS_ERRORS
      res.status(500)
    res.render 'index', content: html, props: JSON.stringify(props)

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
    url = req.query.url
    questions = session.getQuestions(url)
    questions.then (questionArray) ->
      console.log questionArray
    , (err)->
      console.log err



module.exports = sessionController
