Promise = require 'promise'
RookServerObject = require 'rook/lib/models/ServerObject'
class Question extends RookServerObject
  @attributes =
    question:
      dataType: 'string'
      validates:
        presence: true
    questionBoard:
      dataType: 'association'
    votes:
      dataType: 'integer'
    flags:
      dataType: 'integer'


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
