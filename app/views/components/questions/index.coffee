Question = require 'models/question.coffee'
QuestionBoard = require 'models/question.coffee'
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
    @state.socket.disconnect()
    PublishSubscribe.removeAllListenersOn.call document, "ask"
    PublishSubscribe.removeAllListenersOn.call document, "questionAdded"

  componentDidMount: ->
    url = window.location.protocol + '//' + window.location.host + window.location.pathname
    socket = io.connect(url, reconnect: true, multiplex: false)
    @setState socket: socket, ->
      @state.socket.on 'questionAdded', (question) => 
        PublishSubscribe.broadcast.call document, "questionAdded", question
    PublishSubscribe.listen.call document, "questionAdded", (newQuestion) =>
      newQuestionList = _.union(@props.questions, [newQuestion])
      @setProps questions: newQuestionList
    PublishSubscribe.listen.call document, "ask", (newQuestion) =>
      Question.create(question: newQuestion, questionBoard: @props.questionBoardId)

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
