QuestionIndex = require 'views/components/questions/index.coffee'
#session = require 'models/extendedModels/session.coffee'

questionController =

  index: (req, res) ->
    url = req.path.replace('/', '')
    #session.createSession(url)
    props = questions: [
      key: 'abc1'
      question: "What?"
      score: 112
      flags: 2
    ,
      key: 'abc2'
      question: "Why?"
      score: 10
      flags: 0
    ]
    try
      element = React.createElement(QuestionIndex, props)
      html = React.renderToString element
    catch error
      html = error if process.env.SHOW_QS_ERRORS
      res.status(500)
    res.render 'index', content: html, props: JSON.stringify(props)

module.exports = questionController
