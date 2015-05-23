{div, form, textarea, button} = React.DOM
QuestionInput = React.createClass

  displayName: 'QuestionInput'
  
  getInitialState: ->
    questionToAsk: '' 
    questionTmpKey: 0

  updateQuestionToAsk: (ev) ->
    @setState questionTmpKey: (@state.questionTmpKey + 1)
    @setState questionToAsk: question: ev.target.value, score: 5, key: @state.questionTmpKey, flagged: 0 

  handleSubmit: (ev) ->
    ev.preventDefault()
    PublishSubscribe.broadcast.call document, "ask", @state.questionToAsk

  render: ->
    div className: 'question-input',
      div className: 'row',
        div className: 'col-xs-12',
          form className: 'form', onSubmit: @handleSubmit, 
            textarea name: 'questionToAsk', className: 'form-control', onChange: @updateQuestionToAsk
            button name: 'submit', type: 'submit', className: 'btn', 'ASK'

module.exports = QuestionInput
