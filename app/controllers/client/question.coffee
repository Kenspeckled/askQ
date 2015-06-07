QuestionIndex = require 'views/components/questions/index.coffee'
QuestionBoard = require 'models/questionBoard.coffee'

questionController =

  index: (req) ->
    url = req.path.replace(/\//, '').replace(/\?.*/, '')
    questionBoardPropsPromise = new Promise (resolve) ->
      QuestionBoard.findBy({url}).then (questionBoard) ->
        if questionBoard
          resolve questionBoard
        else
          QuestionBoard.create({url}).then (newQuestionBoard) ->
            resolve newQuestionBoard
    questionBoardPropsPromise.then (questionBoard) ->
      # FIXME: using _.union to turn undefined into an empty array
      props = questions: _.union(questionBoard.questions), questionBoardId: questionBoard.id
      try
        React.render(
          React.createElement(QuestionIndex, props)
          document.getElementById('content')
        )
      catch error
        console.log new Error(error) if process.env.SHOW_QS_ERRORS


module.exports = questionController
