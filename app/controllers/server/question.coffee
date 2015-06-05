Promise = require 'promise'
QuestionBoard = require 'models/extendedModels/questionBoard.coffee'
Question = require 'models/extendedModels/question.coffee'
QuestionIndex = require 'views/components/questions/index.coffee'

notFound = (res) ->
  res.sendStatus(404)

questionController =

  showAPI: (req, res) ->
    onSuccess = (questionObject) ->
      res.json questionObject#.toJSON()
    args = req.query
    QuestionBoard.findBy(args).then(onSuccess, notFound.bind(this, res))

  # index: (req, res) ->
  #   url = req.path.replace('/', '')
  #   props = questions: [
  #     key: 'abc1'
  #     question: "What?"
  #     score: 112
  #     flags: 2
  #   ,
  #     key: 'abc2'
  #     question: "Why?"
  #     score: 10
  #     flags: 0
  #   ]
  #   try
  #     element = React.createElement(QuestionIndex, props)
  #     html = React.renderToString element
  #   catch error
  #     html = error if process.env.SHOW_QS_ERRORS
  #     res.status(500)
  #   res.render 'index', content: html, props: JSON.stringify(props)

  index: (req, res) ->
    url = req.params.url
    questionBoardPropsPromise = new Promise (resolve) ->
      QuestionBoard.findBy(url: url).then (questionBoardProps) ->
        console.log questionBoardProps
        if questionBoardProps
          resolve questionBoardProps
        else
          QuestionBoard.create({url}).then (questionBoardProps) ->
            resolve questionBoardProps
    questionBoardPropsPromise.then (questionBoardProps) ->
      try
        element = React.createElement(QuestionIndex, questionBoardProps)
        html = React.renderToString element
      catch error
        html = error if process.env.SHOW_QS_ERRORS
        res.status(500)
      res.render 'index', content: html, props: JSON.stringify(questionBoardProps)

  addQuestion: (req, res) ->
    url = req.params.url
    question = req.params.question
    console.log question
    QuestionBoard.findBy({url}).then (questionBoard) ->
      console.log questionBoard
      Question.create({question}, questionBoard:questionBoard.id).then (question) ->
        console.log question
        QuestionBoard.update(questionBoard.id, questions: [question.id], true)

  # vote: (req, res) ->
  #   questionNumber = req.body.questionNumber
  #   condition = req.body.condition
  #   session.vote(questionNumber, condition)

  # flag: (req, res) ->
  #   questionNumber = req.body.questionNumber
  #   session.flag(questionNumber)

  # index: (req, res) ->
  #   url = req.query.url
  #   questions = session.getQuestions(url)
  #   questions.then (questionArray) ->
  #     console.log questionArray
  #   , (err)->
  #     console.log err



module.exports = questionController
