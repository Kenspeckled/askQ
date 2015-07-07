QuestionIndex = require 'views/components/questions/index.coffee'
QuestionBoard = require 'models/questionBoard.coffee'

urlString = (str) ->
  return null if str == ''
  str = decodeURIComponent(str)
    .replace(/'/g, '')
    .replace(/\%/g, 'percent')
    .replace(/\£/g, 'pounds')
    .replace(/\$/g, 'dollars')
    .replace(/&|\+/g, 'and')
    .replace(/[^a-z0-9_]+/g, '-')
    .replace(/^-|-$/g, '')
    .toLowerCase()
  str

questionController =

  index: (req) ->
    url = req.path.replace(/\//, '').replace(/\?.*/, '')
    url = urlString(url)
    window.history.replaceState path: url, null, url
    questionBoardPropsPromise = new Promise (resolve) ->
      QuestionBoard.findBy({url}).then (questionBoard) ->
        if questionBoard
          resolve questionBoard
        else
          QuestionBoard.create({url}).then (newQuestionBoard) ->
            resolve newQuestionBoard
    questionBoardPropsPromise.then (questionBoard) ->
      props = {questionBoard}
      try
        React.render(
          React.createElement(QuestionIndex, props)
          document.getElementById('content')
        )
      catch error
        console.log new Error(error) if process.env.SHOW_QS_ERRORS


module.exports = questionController
