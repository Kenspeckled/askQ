{header, div, a, h1, img} = React.DOM

Header = React.createClass 

  displayName: 'Header'

  render: ->
    header id: 'header',
      div className: 'container',
        div className: 'row',
          div className: 'col-sm-12',
            a href: '/',
              h1 className: 'site-title sr-only', 'Qs'
              img className: 'logo', src: '/assets/images/askQ_logo.png', alt: 'AskQ'

module.exports = Header
