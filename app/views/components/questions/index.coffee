QuestionBubble = require 'views/components/questions/_QuestionBubble.coffee'
{div} = React.DOM

class QuestionIndex extends React.Component

  displayName: 'QuestionIndex'

  render: ->
    div id: 'question-index', className: 'container',
      div className: 'row',
        div className: 'col-sm-12',
          for question in @props.questions
            React.createElement QuestionBubble, question 
          

module.exports = QuestionIndex
