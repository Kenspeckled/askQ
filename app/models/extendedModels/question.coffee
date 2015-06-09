Promise = require 'promise'
ClientQuestion = require 'models/question.coffee'
ooRecordsORMClassMethods = require 'models/extendedModels/modules/ooRecordsORMClassMethods.coffee'
class Question extends ClientQuestion
  @extend ooRecordsORMClassMethods

  @vote: (questionId, voteDirection) ->
    if voteDirection == 'down'
      voteModifier = -1 
    else if voteDirection == 'up'
      voteModifier = 1 
    votePromise = new Promise (resolve, reject) =>
      @client.hincrby 'Question:' + questionId, 'votes', voteModifier, (error, res) =>
        if error
          reject()
        else
          resolve()
    votePromise.then =>
      @find(questionId)

module.exports = Question
