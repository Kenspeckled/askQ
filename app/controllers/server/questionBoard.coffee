QuestionBoard = require 'models/extendedModels/questionBoard.coffee'

notFound = (res) ->
  res.sendStatus(404)

questionBoardController =

  apiCreate: (req, res) ->
    QuestionBoard.create({url: req.body.url}).then (questionBoard) ->
      req.io.of('/'+questionBoard.url) # ensure namespace exists
      res.status(200)
      res.json questionBoard 
    , (errors) ->
      errorMessage = _.map(errors, 'message').join ' '
      res.status(500)
      res.send (if process.env.SHOW_QS_ERRORS then errorMessage else false)

  apiShow: (req, res) ->
    onSuccess = (questionBoard) ->
      res.json questionBoard
    QuestionBoard.findBy(req.query).then(onSuccess, notFound.bind(this, res))

module.exports = questionBoardController
