{div} = React.DOM

class QuestionList extends React.Component

  displayName: 'QuestionList'

  render: ->
    div id: 'question-index',
      div className: 'row',
        div className: 'col-sm-12',
          div null, 'hello'

module.exports = QuestionList
