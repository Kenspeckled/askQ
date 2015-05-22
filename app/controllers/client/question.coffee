QuestionIndex = require 'views/components/questions/index.coffee'

questionController =

  index: (ctx) ->
    console.log ctx.params.url
    props = {}
    React.render(
      React.createElement(QuestionIndex, props),
      document.getElementById('content')
    )

module.exports = questionController
