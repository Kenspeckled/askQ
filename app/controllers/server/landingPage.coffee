LandingPage = require 'views/components/landingPage/index.coffee'

landingPageController =

  index: (req, res) ->
    props = {}
    try
      element = React.createElement(LandingPage, props)
      html = React.renderToString element
    catch error
      html = error if process.env.SHOW_QS_ERRORS
      res.status(500)
    res.render 'index', content: html, props: JSON.stringify(props)

module.exports = landingPageController
