QuestionInput = require 'views/components/questions/_QuestionInput.coffee'
QuestionBubble = require 'views/components/questions/_QuestionBubble.coffee'

{div} = React.DOM

QuestionIndex = React.createClass

  displayName: 'QuestionIndex'

  render: ->
    div id: 'question-index', className: 'container',
      div className: 'row',
        div className: 'col-sm-12',
          for question in @props.questions
            React.createElement QuestionBubble, question 
      div className: 'row',
        div className: 'col-sm-12',
          React.createElement QuestionInput
          

module.exports = QuestionIndex
