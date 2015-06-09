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
    Question.findBy(req.query).then(onSuccess, notFound.bind(this, res))

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

  apiVote: (req, res) ->
    try
      Question.vote(req.params.id, req.params.direction).then (question) ->
        QuestionBoard.find(question.questionBoard).then (questionBoard) ->
          req.io.of('/'+questionBoard.url).emit 'questionVote', question
          res.status(200)
          res.send true
    catch error
      console.log error
      res.status(500)
      res.send (if process.env.SHOW_QS_ERRORS then error else false)

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
