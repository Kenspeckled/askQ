Question = require 'models/question.coffee'

{div, button} = React.DOM

QuestionBubble = React.createClass

  displayName: 'QuestionBubble'

  upVote: ->
    Question.vote(@props.id, 'up')

  downVote: ->
    Question.vote(@props.id, 'down')

  render: ->
    div className: 'question-bubble',
      div className: 'question-container',
        div className: 'question',
          div null, @props.question
        div className: 'actions',
          button className: 'up-vote', type: 'button', onClick: @upVote
          div className: 'score', (@props.votes || 0)
          button className: 'down-vote', type: 'button', onClick: @downVote

module.exports = QuestionBubble
