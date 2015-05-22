{div, h1, form, input, button} = React.DOM

class LandingPage extends React.Component

  displayName: 'LandingPage'

  getInitialState: ->
    url: null

  handleUrlChange: (ev) =>
    @setState url: ev.target.value

  handleSubmit: (ev) =>
    ev.preventDefault()
    console.log "go to " + @state.url

  render: ->
    div id: 'landing-page', className: 'fluid-container',
      div className: 'row',
        div className: 'col-sm-12',
          h1 null, 'Qs'
      div className: 'row',
        div className: 'col-sm-12',
          form onSubmit: @handleSubmit,
            input type: 'text', name: 'new-session', onChange: @handleUrlChange
            button type: 'submit', name: 'new-session', 'Create URL'


module.exports = LandingPage
