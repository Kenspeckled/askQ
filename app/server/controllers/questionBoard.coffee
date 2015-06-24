QuestionBoard = require 'models/questionBoard.coffee'

notFound = (res) ->
  res.sendStatus(404)

questionBoardController =

  apiCreate: (req, res) ->
    QuestionBoard.create({url: req.body.url, description: req.body.description}).then (questionBoard) ->
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
    onNotFound = ->
      QuestionBoard.create({url: req.query.url, description: req.query.description}).then (questionBoard) ->
        req.io.of('/'+questionBoard.url) # ensure namespace exists
        res.json questionBoard 
    findByArgs = if req.params.id then {id: req.params.id} else req.query
    QuestionBoard.findBy(findByArgs).then(onSuccess, onNotFound)

module.exports = questionBoardController
