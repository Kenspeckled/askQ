Header = require 'views/components/header/_Header.coffee'
{div, header, h1, img, form, input, a} = React.DOM

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
    url: null

  componentDidMount: ->
    @setState url: @generateRandomUrl()

  handleUrlChange: (ev) ->
    @setState url: ev.target.value

  render: ->
    div id: 'landing-page',
      React.createElement(Header, @props)
      div className: 'main',
        div className: 'container',
          div className: 'row',
            div className: 'col-sm-12',
              form onSubmit: @handleSubmit,
                input type: 'text', name: 'new-session', onChange: @handleUrlChange, value: @state.url
                a className: 'btn', href: '/'+@state.url, 'Join Question Board'


module.exports = LandingPage
