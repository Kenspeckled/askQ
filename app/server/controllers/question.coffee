Promise = require 'promise'
QuestionBoard = require 'models/questionBoard.coffee'
Question = require 'models/question.coffee'
Session = require 'models/session.coffee'

QuestionIndex = require 'views/components/questions/index.coffee'

notFound = (res) ->
  res.sendStatus(404)

urlString = (str) ->
  return null if str == ''
  str = str
    .replace(/'/g, '')
    .replace(/\%/g, 'percent')
    .replace(/\£/g, 'pounds')
    .replace(/\$/g, 'dollars')
    .replace(/&|\+/g, 'and')
    .replace(/[^a-z0-9_]+/g, '-')
    .replace(/^-|-$/g, '')
    .toLowerCase()
  str

createNewSession = ->
  d = new Date()
  sessionId = (+d).toString(36) + _utilities.randomString(28)
  Session.create({sessionId}).then (session) ->
    console.log "NEW SESSION", session
  sessionId

checkUserCanVoteForQuestion = (sessionId, questionId) ->
  new Promise (resolve) ->
    Session.findBy(sessionId: sessionId).then (session) ->
      console.log session
      resolve(true)
      #resolve(false)
    , ->
      resolve(true)

questionController =

  apiIndex: (req, res) ->
    onSuccess = (questionBoard) ->
      res.cookie 'session', createNewSession() unless req.cookies.session
      res.json questionBoard#.toJSON()
    url = req.query.url
    QuestionBoard.findBy(url: url).then(onSuccess, notFound.bind(this, res))

  apiShow: (req, res) ->
    onSuccess = (questionObject) ->
      res.json questionObject#.toJSON()
    findByArgs = if req.params.id then {id: req.params.id} else req.query
    Question.findBy(findByArgs).then(onSuccess, notFound.bind(this, res))

  apiCreate: (req, res) ->
    Question.create(question: req.body.question, questionBoard: req.body.questionBoard).done (question) ->
      updateSession = new Promise (resolve) ->
        Session.findBy(sessionId: req.cookies.session).then (session) ->
          Session.update(session.id, askedQuestions: [question.id], true).then ->
            resolve()
        , ->
          resolve()
      updateSession.then ->
        req.io.of('/'+question.questionBoard.url).emit 'questionAdded', question
        res.status(200)
        res.send true
    , (error) ->
      res.status(500)
      res.send (if process.env.SHOW_QS_ERRORS then error else false)

  apiVote: (req, res) ->
    try
      checkUserCanVoteForQuestion(req.cookies.session, req.params.id).then (canVote) ->
        if canVote 
          Question.vote(req.params.id, req.params.direction).then (question) ->
            updateSession = new Promise (resolve) ->
              Session.findBy(sessionId: req.cookies.session).then (session) ->
                Session.update(session.id, votedQuestions: [question.id], true).then ->
                  resolve()
              , ->
                resolve()
            updateSession.then ->
              req.io.of('/'+question.questionBoard.url).emit 'questionVote', question
              res.status(200)
              res.send true
        else
          Question.find(req.params.id).then (question) ->
            req.io.of('/'+question.questionBoard.url).emit 'voteNotValid', question
            res.status(400)
            res.send false 
    catch error
      console.log error
      res.status(500)
      res.send (if process.env.SHOW_QS_ERRORS then error else false)

  index: (req, res) ->
    url = req.params.url
    description = req.query.description
    questionBoardPropsPromise = new Promise (resolve) ->
      QuestionBoard.findBy({url}).then (questionBoard) ->
        resolve questionBoard
      , ->
        url = urlString(req.params.url)
        safeDescription = req.query.description.replace(/[^a-z0-9_]+/g, '')
        QuestionBoard.create({url, description: safeDescription}).then (newQuestionBoard) ->
          req.io.of('/'+newQuestionBoard.url) # ensure namespace exists
          resolve newQuestionBoard
    questionBoardPropsPromise.then (questionBoard) ->
      props = {questionBoard}
      try
        element = React.createElement(QuestionIndex, props)
        html = React.renderToString element
      catch error
        html = error if process.env.SHOW_QS_ERRORS
        res.status(500)
      res.cookie 'session', createNewSession() unless req.cookies.session
      res.render 'index', content: html, props: JSON.stringify(props)


module.exports = questionController
