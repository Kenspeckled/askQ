QuestionBoard = require 'models/questionBoard.coffee'

notFound = (res) ->
  res.sendStatus(404)

urlString = (str) ->
  return null if str == ''
  str = str
    .replace(/\'/g, '')
    .replace(/\%/g, 'percent')
    .replace(/\£/g, 'pounds')
    .replace(/\$/g, 'dollars')
    .replace(/&|\+/g, 'and')
    .replace(/[^a-z0-9_]+/g, '-')
    .replace(/^-|-$/g, '')
    .toLowerCase()
  str

questionBoardController =

  apiCreate: (req, res) ->
    url = urlString(req.body.url)
    safeDescription = if req.body.description then req.body.description.replace(/[^a-zA-Z0-9_!?& ]+/g, '') else null
    QuestionBoard.create({url, description: safeDescription}).then (questionBoard) ->
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
      url = urlString(req.query.url)
      safeDescription = if req.query.description then req.query.description.replace(/[^a-zA-Z0-9_!?& ]+/g, '') else null
      QuestionBoard.create({url, description: safeDescription}).then (questionBoard) ->
        req.io.of('/'+questionBoard.url) # ensure namespace exists
        res.json questionBoard 
    findByArgs = if req.params.id then {id: req.params.id} else req.query
    QuestionBoard.findBy(findByArgs).then(onSuccess, onNotFound)

module.exports = questionBoardController
