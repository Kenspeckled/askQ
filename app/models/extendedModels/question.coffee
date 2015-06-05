ClientQuestion = require 'models/question.coffee'
ooRecordsORMClassMethods = require 'models/extendedModels/modules/ooRecordsORMClassMethods.coffee'
class Question extends ClientQuestion
  @extend ooRecordsORMClassMethods

module.exports = Question
