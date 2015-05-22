{div, h1, form, input, button} = React.DOM

LandingPage = React.createClass 

  displayName: 'LandingPage'

  generateRandomUrl: ->
    word1Array = ['two', 'three', 'four']
    word2Array = ['orange', 'green', 'blue']
    word3Array = ['rocks', 'papers', 'scissors']
    url = []
    url.push word1Array[Math.floor(Math.random()*word1Array.length)]
    url.push word2Array[Math.floor(Math.random()*word2Array.length)]
    url.push word3Array[Math.floor(Math.random()*word3Array.length)]
    url.join '-'

  getInitialState: ->
    url: @generateRandomUrl()

  handleUrlChange: (ev) ->
    @setState url: ev.target.value

  handleSubmit: (ev) ->
    ev.preventDefault()
    window.location = @state.url

  render: ->
    div id: 'landing-page', className: 'fluid-container',
      div className: 'row',
        div className: 'col-sm-12',
          h1 null, 'Qs'
      div className: 'row',
        div className: 'col-sm-12',
          form onSubmit: @handleSubmit,
            input type: 'text', name: 'new-session', onChange: @handleUrlChange, value: @state.url
            button type: 'submit', name: 'new-session', 'Create URL'


module.exports = LandingPage
