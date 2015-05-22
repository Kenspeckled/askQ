QuestionIndex = require 'views/components/questions/index.coffee'
session = require 'models/extendedModels/session'

questionController =

  index: (req, res) ->
    url = req.path.replace('/', '')
    session.createSession(url)
    props = {}
    try
      element = React.createElement(QuestionIndex, props)
      html = React.renderToString element
    catch error
      html = error if process.env.SHOW_QS_ERRORS
      res.status(500)
    res.render 'index', content: html, props: JSON.stringify(props)

module.exports = questionController
