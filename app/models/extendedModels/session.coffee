RookServerObject = require 'rook/lib/models/ServerObject'
class Session extends RookServerObject
  @attributes =
    sessionId:
      dataType: 'string'
      identifiable: true
      validates:
        presence: true
        uniqueness: true
    votedQuestions:
      dataType: 'association'
      many: true
    askedQuestions:
      dataType: 'association'
      many: true

module.exports = Session
