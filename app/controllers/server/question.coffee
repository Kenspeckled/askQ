Promise = require 'promise'
QuestionBoard = require 'models/extendedModels/questionBoard.coffee'
Question = require 'models/extendedModels/question.coffee'
QuestionIndex = require 'views/components/questions/index.coffee'

notFound = (res) ->
  res.sendStatus(404)

questionController =

  apiIndex: (req, res) ->
    onSuccess = (questionBoard) ->
      res.json questionBoard#.toJSON()
    url = req.query.url
    findPromise = QuestionBoard.findBy(url: url).then(onSuccess, notFound.bind(this, res))

  apiShow: (req, res) ->
    onSuccess = (questionObject) ->
      res.json questionObject#.toJSON()
    id = req.params.id
    Question.find(id).then(onSuccess, notFound.bind(this, res))

  apiCreate: (req, res) ->
    try
      Question.create(question: req.body.question, questionBoard: req.body.questionBoard).done (question) ->
        QuestionBoard.update(question.questionBoard, questions: [question.id], true).done (questionBoard) ->
          req.io.of('/'+questionBoard.url).emit 'questionAdded', question
          res.status(200)
          res.send true
    catch error
      res.status(500)
      res.send (if process.env.SHOW_QS_ERRORS then error else false)

  apiCreateBoard: (req, res) ->
    QuestionBoard.create({url: req.body.url}).then (questionBoard) ->
      req.io.of('/'+questionBoard.url) # ensure namespace exists
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
            req.io.of('/'+newQuestionBoard.url) # ensure namespace exists
            resolve newQuestionBoard
    questionBoardPropsPromise.then (questionBoard) ->
      props = questions: (questionBoard.questions || []), questionBoardId: questionBoard.id
      try
        element = React.createElement(QuestionIndex, props)
        html = React.renderToString element
      catch error
        html = error if process.env.SHOW_QS_ERRORS
        res.status(500)
      res.render 'index', content: html, props: JSON.stringify(props)





module.exports = questionController
