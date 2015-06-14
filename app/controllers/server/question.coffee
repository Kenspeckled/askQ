Promise = require 'promise'
QuestionBoard = require 'models/extendedModels/questionBoard.coffee'
Question = require 'models/extendedModels/question.coffee'
QuestionIndex = require 'views/components/questions/index.coffee'
Session = require 'models/extendedModels/session.coffee'

notFound = (res) ->
  res.sendStatus(404)

createNewSession = ->
  d = new Date()
  sessionId = (+d).toString(36) + _utilities.randomString(28)
  Session.create({sessionId}).then (session) ->
    console.log "NEW SESSION", session
  sessionId


checkUserCanVoteForQuestion = (sessionId, questionId) ->
  console.log 'finding session '+ sessionId
  Session.findBy(sessionId: sessionId).then (session) ->
    console.log "SESSION", session
  , (error) ->
    console.log error
  true

questionController =

  apiIndex: (req, res) ->
    onSuccess = (questionBoard) ->
      res.cookie 'session', createNewSession() unless req.cookies.session
      res.json questionBoard#.toJSON()
    url = req.query.url
    findPromise = QuestionBoard.findBy(url: url).then(onSuccess, notFound.bind(this, res))

  apiShow: (req, res) ->
    onSuccess = (questionObject) ->
      res.json questionObject#.toJSON()
    Question.findBy(req.query).then(onSuccess, notFound.bind(this, res))

  apiCreate: (req, res) ->
    try
      Question.create(question: req.body.question, questionBoard: req.body.questionBoard).then (question) ->
        updateSessionPromise = Session.findBy(sessionId: req.cookies.session).then (session) ->
          Session.update(session.id, askedQuestions: [question.id], true) if session
        updateSessionPromise.then ->
          QuestionBoard.update(question.questionBoard, questions: [question.id], true).done (questionBoard) ->
            req.io.of('/'+questionBoard.url).emit 'questionAdded', question
            res.status(200)
            res.send true
    catch error
      res.status(500)
      res.send (if process.env.SHOW_QS_ERRORS then error else false)

  apiVote: (req, res) ->
    try
      if checkUserCanVoteForQuestion(req.cookies.session, req.params.id)
        Question.vote(req.params.id, req.params.direction).then (question) ->
          updateSessionPromise = Session.findBy(sessionId: req.cookies.session).then (session) ->
            Session.update(session.id, votedQuestions: [question.id], true) if session
          updateSessionPromise.then ->
            QuestionBoard.find(question.questionBoard).then (questionBoard) ->
              req.io.of('/'+questionBoard.url).emit 'questionVote', question
              res.status(200)
              res.send true
      else
        Question.find(req.params.id).then (question) ->
          QuestionBoard.find(question.questionBoard).then (questionBoard) ->
            req.io.of('/'+questionBoard.url).emit 'voteNotValid', question
            res.status(200)
            res.send false 
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
      res.cookie 'session', createNewSession() unless req.cookies.session
      res.render 'index', content: html, props: JSON.stringify(props)


module.exports = questionController
