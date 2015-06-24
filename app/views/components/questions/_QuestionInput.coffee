{div, form, textarea, button, br} = React.DOM

QuestionInput = React.createClass

  displayName: 'QuestionInput'
  
  getInitialState: ->
    asking: false
    questionToAsk: '' 

  updateQuestionToAsk: (ev) ->
    @setState questionToAsk: ev.target.value

  componentDidMount: ->
    publishSubscribe.listen.call document, "questionAsked", =>
      @setState asking: false, questionToAsk: '' 

  handleSubmit: (ev) ->
    ev.preventDefault()
    if @state.questionToAsk != ''
      @setState asking: true
      publishSubscribe.broadcast.call document, "ask", @state.questionToAsk

  render: ->
    div className: 'question-input',
      div className: 'row',
        div className: 'col-xs-12',
          form className: 'form', onSubmit: @handleSubmit, 
            textarea name: 'questionToAsk', className: 'input' + (if @state.asking then ' submitting' else ''), placeholder: 'Your question...', onChange: @updateQuestionToAsk, value: @state.questionToAsk
            br null
            br null
            button name: 'submit', type: 'submit', className: 'btn', disabled: @state.asking, 'Ask'

module.exports = QuestionInput
