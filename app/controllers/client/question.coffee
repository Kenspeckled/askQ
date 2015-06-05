QuestionIndex = require 'views/components/questions/index.coffee'
QuestionBoard = require 'models/questionBoard.coffee'

questionController =

  # index: (ctx) ->
  #   props = questions: [
  #     key: 'abc1'
  #     question: "What?"
  #     score: 112
  #     flags: 2
  #   ,
  #     key: 'abc2'
  #     question: "Why?"
  #     score: 10
  #     flags: 0
  #   ]
  #   React.render(
  #     React.createElement(QuestionIndex, props),
  #     document.getElementById('content')
  #   )

  index: (req) ->
    url = req.path.replace('/', '')
    questionBoardPropsPromise = new Promise (resolve) ->
      QuestionBoard.findBy(url: url).then (questionBoardProps) ->
        if questionBoardProps
          resolve questionBoardProps
        else
          QuestionBoard.create({url, questions:''}).then (questionBoardProps) ->
            resolve questionBoardProps
    questionBoardPropsPromise.then (questionBoardProps) ->
      React.render(
        React.createElement(QuestionIndex, questionBoardProps)
        document.getElementById('content')
      )


module.exports = questionController
