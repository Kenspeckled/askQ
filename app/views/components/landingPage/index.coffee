if _scriptContext.isClient
  ClientRouter = require 'clientRouter/ClientRouter.coffee'

Header = require 'views/components/header/_Header.coffee'
{div, header, h1, h2, img, br, form, label, input, textarea, button, p} = React.DOM

LandingPage = React.createClass

  displayName: 'LandingPage'

  generateRandomUrl: ->
    word1Array = ['angry', 'beautiful', 'slippery', 'wonderful', 'dangerous', 'helpful', 'insightful', 'contaminated', 'human', 'plentiful']
    word2Array = ['monkeys', 'children', 'politicians', 'knives', 'recepies', 'horses', 'nightmares', 'potatoes', 'pies', 'poetry']
    url = []
    url.push word1Array[Math.floor(Math.random()*word1Array.length)]
    url.push word2Array[Math.floor(Math.random()*word2Array.length)]
    url.join '-'

  getInitialState: ->
    url: null
    description: null

  componentDidMount: ->
    @setState url: @generateRandomUrl()

  handleUrlChange: (ev) ->
    urlString = (str) ->
      return null if str == ''
      str = str
        .replace(/'/g, '')
        .replace(/\%/g, 'percent')
        .replace(/\£/g, 'pounds')
        .replace(/\$/g, 'dollars')
        .replace(/&|\+/g, 'and')
        .replace(/[^a-z0-9_]+/g, '-')
        .replace(/^-|-$/g, '')
        .toLowerCase()
      str
    @setState url: urlString(ev.target.value)

  handleDescriptionChange: (ev) ->
    @setState description: ev.target.value.replace(/[^a-z0-9_!?&]+/g, '')

  handleSubmit: (ev) ->
    ev.preventDefault()
    url = @state.url
    url += '?description=' + @state.description if @state.description
    window.location = url

  render: ->
    div className: 'landing-page',
      React.createElement(Header, @props)
      div className: 'main',
        div className: 'container',
          div className: 'row',
            div className: 'col-sm-12',
              h1 null, 'Real-time question board'
          div className: 'row',
            div className: 'col-sm-12',
              form className: 'question-board-form', onSubmit: @handleSubmit,
                div className: 'row',
                  div className: 'col-sm-2',
                    div className: 'input-label', 'askq.co/'
                  div className: 'col-sm-10',
                    input className: 'input', type: 'text', name: 'question-board-url', onChange: @handleUrlChange, placeholder: 'Question board name', value: @state.url
                div className: 'row',
                  div className: 'col-sm-10 col-sm-offset-2',
                    textarea className: 'input', name: 'question-board-description', placeholder: 'Description', onChange: @handleDescriptionChange, value: @state.description
                div className: 'row',
                  div className: 'col-sm-10 col-sm-offset-2',
                    button className: 'btn', type: 'submit', 'Start Asking Questions'
          div className: 'row',
            div className: 'col-sm-12',
              h2 null, "Find the questions on everyone's mind"
              p null, "Q&A session are sometimes the most engaging part of a talk or presentation, that is if the questions asked are relevant and interesting to the whole audience. AskQ allows audiences to ask and vote for questions and ranks the top questions."
              p null, "Create a new qustion and description for your question board. Question boards are public and anyone navigating to that address will be able to access your question board and ask new questions."
              p null, "Share your question url with your audience and see questions and votes appear in real-time."
              p null, "Refreshing the page will reorder the questions with the highest votes appearing at the top. Sessions are temporary and will expire within 12 hours of inactivity (no new votes or new questions)."

module.exports = LandingPage
