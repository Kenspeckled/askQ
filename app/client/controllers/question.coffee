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
      props = questions: (questionBoard.questions || []), questionBoardId: questionBoard.id
      try
        React.render(
          React.createElement(QuestionIndex, props)
          document.getElementById('content')
        )
      catch error
        console.log new Error(error) if process.env.SHOW_QS_ERRORS


module.exports = questionController
