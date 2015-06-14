RookClientObject = require 'rook/lib/models/ClientObject'
class QuestionBoard extends RookClientObject
  @showPath = 'api/question-board/show'
  @createPath = 'api/question-board/new'

module.exports = QuestionBoard
