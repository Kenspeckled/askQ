Question = require 'models/question.coffee'

class QuestionBoard extends ObjectOrientedRecord
  @showPath = 'api/question/index'
  @createPath = 'api/question-board/new'
  @attributes =
    url:
      dataType: 'string'
      identifiable: true
      validates:
        presence: true
        uniqueness: true
    questions:
      dataType: 'association'
      many: true
      preloadModel: Question

module.exports = QuestionBoard
