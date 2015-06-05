Question = require 'models/extendedModels/question.coffee'
ClientQuestionBoard = require 'models/questionBoard.coffee'
ooRecordsORMClassMethods = require 'models/extendedModels/modules/ooRecordsORMClassMethods.coffee'
class QuestionBoard extends ClientQuestionBoard
  @extend ooRecordsORMClassMethods
  @attributes =
    questions:
      dataType: 'association'
      many: true
      preloadModel: Question

module.exports = QuestionBoard
