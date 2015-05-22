{div} = React.DOM

class QuestionBubble extends React.Component

  displayName: 'QuestionBubble'

  render: ->
    div className: 'question-bubble',
      div className: 'row',
        div className: 'col-xs-12',
          div className: 'row',
            div className: 'col-xs-10',
              div null, @props.question
            div className: 'col-xs-2',
              div className: 'up-vote'
              div null, @props.score
              div className: 'down-vote'

module.exports = QuestionBubble
