Session = require 'models/extendedModels/session'
Question = require 'models/extendedModels/question'
QuestionIndex = require 'views/components/questions/index.coffee'

sessionController =

  session: (req, res) ->
    props =
      url: req.path.replace('/', '')
      questions: ''
    Session.create(props).then (sessionProps) ->
      try
        element = React.createElement(QuestionIndex, sessionProps)
        html = React.renderToString element
      catch error
        html = error if process.env.SHOW_QS_ERRORS
        res.status(500)
      res.render 'index', content: html, props: JSON.stringify(sessionProps)

  addQuestion: (req, res) ->
    url = req.body.sessionUrl
    question = req.body.question
    Session.findBy({url}).then (session) ->
      Question.create({question}, session:session.id).then (question) ->
        # Session.update(session.id, questions: [question.id], true)

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
