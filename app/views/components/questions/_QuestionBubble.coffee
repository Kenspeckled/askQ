Question = require 'models/question.coffee'

{div, button} = React.DOM

QuestionBubble = React.createClass

  displayName: 'QuestionBubble'

  getInitialState: ->
    vote: 0

  upVote: (ev) ->
    ev.preventDefault()
    if @state.vote < 1
      Question.vote(@props.id, 'up')
      @setState vote: @state.vote + 1

  downVote: (ev) ->
    ev.preventDefault()
    if @state.vote > -1
      Question.vote(@props.id, 'down')
      @setState vote: @state.vote - 1

  render: ->
    div className: 'question-bubble',
      div className: 'question-container',
        div className: 'question',
          div null, @props.question
        div className: 'actions',
          button className: 'up-vote' + (if @state.vote == 1 then ' voted' else ''), type: 'button', onClick: @upVote
          div className: 'score', (@props.votes || 0)
          button className: 'down-vote' + (if @state.vote == -1 then ' voted' else ''), type: 'button', onClick: @downVote

module.exports = QuestionBubble
