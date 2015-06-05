{div, form, textarea, button} = React.DOM

QuestionInput = React.createClass

  displayName: 'QuestionInput'
  
  getInitialState: ->
    questionToAsk: '' 

  updateQuestionToAsk: (ev) ->
    @setState questionToAsk: ev.target.value

  handleSubmit: (ev) ->
    ev.preventDefault()
    console.log "ASK " + @state.questionToAsk

  render: ->
    div className: 'question-input',
      div className: 'row',
        div className: 'col-xs-12',
          form className: 'form', onSubmit: @handleSubmit, 
            textarea name: 'questionToAsk', className: 'form-control', onChange: @updateQuestionToAsk
            button type: 'submit', className: 'btn', 'ASK'

module.exports = QuestionInput
