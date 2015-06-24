{header, div, a, h1, img} = React.DOM

Header = React.createClass 

  displayName: 'Header'

  render: ->
    header className: 'header',
      div className: 'container',
        div className: 'row',
          div className: 'col-sm-2',
            a href: '/',
              h1 className: 'site-title sr-only', 'AskQ'
              img className: 'logo', src: '/assets/images/askQ_logo.png', alt: 'AskQ'
          div className: 'col-sm-10',
            if @props.questionBoard and @props.questionBoard.description
              div className: 'url', 'askq.co/' + @props.questionBoard.url
          div className: 'col-sm-10',
            if @props.questionBoard and @props.questionBoard.description
              div className: 'description', @props.questionBoard.description

module.exports = Header
