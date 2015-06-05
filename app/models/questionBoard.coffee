Question = require 'models/question.coffee'

class QuestionBoard extends ObjectOrientedRecord
  # @addQuestionPath = 'api/add-question'
  # @votePath = 'api/vote'
  # @flagPath = 'api/flag'
  # @indexPath = 'api/all-questions'
  @showPath = 'api/question/show.json'
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
