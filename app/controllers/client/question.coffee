QuestionIndex = require 'views/components/questions/index.coffee'

questionController =

  index: (ctx) ->
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
    React.render(
      React.createElement(QuestionIndex, props),
      document.getElementById('content')
    )

module.exports = questionController
