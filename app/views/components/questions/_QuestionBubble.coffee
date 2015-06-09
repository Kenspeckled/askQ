{div} = React.DOM

class QuestionBubble extends React.Component

  displayName: 'QuestionBubble'

  render: ->
    div className: 'question-bubble',
      div className: 'question-container',
        div className: 'question',
          div null, @props.question
        div className: 'actions',
          div className: 'up-vote'
          div className: 'score', (@props.score || 0)
          div className: 'down-vote'

module.exports = QuestionBubble
