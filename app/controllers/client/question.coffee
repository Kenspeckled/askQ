QuestionIndex = require 'views/components/questions/index.coffee'

questionController =

  index: (ctx) ->
    props = {}
    React.render(
      React.createElement(QuestionIndex, props),
      document.getElementById('content')
    )

module.exports = questionController
