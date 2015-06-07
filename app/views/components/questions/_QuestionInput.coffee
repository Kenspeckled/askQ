{div, form, textarea, button} = React.DOM

QuestionInput = React.createClass

  displayName: 'QuestionInput'
  
  getInitialState: ->
    asking: false
    questionToAsk: '' 

  updateQuestionToAsk: (ev) ->
    @setState questionToAsk: ev.target.value

  componentDidMount: ->
    PublishSubscribe.listen.call document, "questionAdded", (question) =>
      @setState asking: false, questionToAsk: '' 

  handleSubmit: (ev) ->
    ev.preventDefault()
    if @state.questionToAsk != ''
      @setState asking: true
      PublishSubscribe.broadcast.call document, "ask", @state.questionToAsk

  render: ->
    div className: 'question-input',
      div className: 'row',
        div className: 'col-xs-12',
          form className: 'form', onSubmit: @handleSubmit, 
            textarea name: 'questionToAsk', className: 'form-control' + (if @state.asking then ' submitting'), onChange: @updateQuestionToAsk, value: @state.questionToAsk
            button name: 'submit', type: 'submit', className: 'btn', disabled: @state.asking, 'ASK'

module.exports = QuestionInput
