Question = require 'models/extendedModels/question.coffee'
RookServerObject = require 'rook/lib/models/ServerObject'
class QuestionBoard extends RookServerObject
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
