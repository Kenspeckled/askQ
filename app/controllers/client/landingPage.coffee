LandingPage = require 'views/components/landingPage/index.coffee'

landingPageController =

  index: (ctx) ->
    props = {}
    try
      React.render(
        React.createElement(LandingPage, props),
        document.getElementById('content')
      )
    catch error
      console.log new Error(error) if process.env.SHOW_QS_ERRORS

module.exports = landingPageController
