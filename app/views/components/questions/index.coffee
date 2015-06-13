Question = require 'models/question.coffee'
QuestionBoard = require 'models/questionBoard.coffee'
Header = require 'views/components/header/_Header.coffee'
QuestionInput = require 'views/components/questions/_QuestionInput.coffee'
QuestionBubble = require 'views/components/questions/_QuestionBubble.coffee'
io = require 'socket.io-client'

{div, p} = React.DOM

QuestionIndex = React.createClass

  displayName: 'QuestionIndex'

  getInitalState: ->
    socket: {}

  componentWillUnmount: ->
    @props.socket.disconnect()
    PublishSubscribe.removeAllListenersOn.call document, "ask"
    PublishSubscribe.removeAllListenersOn.call document, "questionAdded"
    PublishSubscribe.removeAllListenersOn.call document, "questionListUpdated"

  componentDidMount: ->
    url = window.location.protocol + '//' + window.location.host + window.location.pathname
    socket = io.connect(url, reconnect: true, multiplex: false)
    @setProps socket: socket, =>
      @props.socket.on 'questionAdded', -> 
        PublishSubscribe.broadcast.call document, "questionListUpdated"
      @props.socket.on 'questionVote', -> 
        PublishSubscribe.broadcast.call document, "questionListUpdated"
    PublishSubscribe.listen.call document, "questionListUpdated", =>
      QuestionBoard.findBy(id: @props.questionBoardId).done (questionBoard) =>
        @setProps questions: questionBoard.questions
    PublishSubscribe.listen.call document, "ask", (newQuestion) =>
      Question.create(question: newQuestion, questionBoard: @props.questionBoardId).then ->
        PublishSubscribe.broadcast.call document, "questionAsked"

  render: ->
    div id: 'question-index',
      React.createElement(Header, @props)
      div className: 'container main',
        div className: 'row',
          if @props.questions.length > 0
            for question in @props.questions
              div className: 'col-sm-12 col-md-6',
                React.createElement QuestionBubble, question
          else
            p className: 'no-questions', 'No Questions have been asked yet. Be the first...'
        div className: 'row',
          div className: 'col-sm-12',
            React.createElement QuestionInput

module.exports = QuestionIndex
