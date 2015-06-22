Promise = require 'promise'
class Question extends ObjectOrientedRecord
  @attributes =
    question:
      dataType: 'string'
      validates:
        presence: true
    questionBoard:
      dataType: 'reference'
      referenceModelName: 'QuestionBoard'
      reverseReferenceAttribute: 'questions'
    sessionOwner:
      dataType: 'reference'
      referenceModelName: 'Session'
    votes:
      dataType: 'integer'


  @vote: (questionId, voteDirection) ->
    if voteDirection == 'down'
      voteModifier = -1 
    else if voteDirection == 'up'
      voteModifier = 1 
    votePromise = new Promise (resolve, reject) =>
      @redis.hincrby 'Question:' + questionId, 'votes', voteModifier, (error, res) =>
        if error
          reject()
        else
          resolve()
    votePromise.then =>
      @find(questionId)

module.exports = Question
