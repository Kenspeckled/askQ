LandingPage = require 'views/components/landingPage/index.coffee'

landingPageController =

  index: (ctx) ->
    props = {}
    React.render(
      React.createElement(LandingPage, props),
      document.getElementById('content')
    )

module.exports = landingPageController
