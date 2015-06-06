Promise = require 'promise'
QuestionBoard = require 'models/extendedModels/questionBoard.coffee'
Question = require 'models/extendedModels/question.coffee'
QuestionIndex = require 'views/components/questions/index.coffee'

notFound = (res) ->
  res.sendStatus(404)

questionController =

  apiIndex: (req, res) ->
    onSuccess = (questionObject) ->
      res.json questionObject#.toJSON()
    url = req.query.url
    QuestionBoard.findBy(url: url).then(onSuccess, notFound.bind(this, res))

  apiShow: (req, res) ->
    onSuccess = (questionObject) ->
      res.json questionObject#.toJSON()
    id = req.params.id
    Question.find(id).then(onSuccess, notFound.bind(this, res))

  apiCreate: (req, res) ->
    try
      QuestionBoard.findBy(url: req.body.questionBoardUrl).then (questionBoard) ->
        Question.create({question: req.body.question}, questionBoard: questionBoard.id).then (question) ->
          QuestionBoard.update(questionBoard.id, questions: [question.id], true).then ->
            res.status(200)
            res.send true
    catch error
      res.status(500)
      res.send (if process.env.SHOW_QS_ERRORS then error else false)

  apiCreateBoard: (req, res) ->
    QuestionBoard.create({url: req.query.url}).then (questionBoard) ->
      res.status(200)
      res.json questionBoard 
    , (errors) ->
      errorMessage = _.map(errors, 'message').join ' '
      res.status(500)
      res.send (if process.env.SHOW_QS_ERRORS then errorMessage else false)

  # apiVote: (req, res) ->
  #   questionNumber = req.body.questionNumber
  #   condition = req.body.condition
  #   session.vote(questionNumber, condition)

  # apiFlag: (req, res) ->
  #   questionNumber = req.body.questionNumber
  #   session.flag(questionNumber)

  index: (req, res) ->
    url = req.params.url
    questionBoardPropsPromise = new Promise (resolve) ->
      QuestionBoard.findBy({url}).then (questionBoard) ->
        if questionBoard
          resolve questionBoard
        else
          QuestionBoard.create({url}).then (newQuestionBoard) ->
            resolve newQuestionBoard
    questionBoardPropsPromise.then (questionBoard) ->
      props = questionBoard
      try
        element = React.createElement(QuestionIndex, props)
        html = React.renderToString element
      catch error
        html = error if process.env.SHOW_QS_ERRORS
        res.status(500)
      res.render 'index', content: html, props: JSON.stringify(props)





module.exports = questionController
