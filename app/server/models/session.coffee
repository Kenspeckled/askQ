class Session extends ObjectOrientedRecord
  @attributes =
    sessionId:
      dataType: 'string'
      identifiable: true
      validates:
        presence: true
        uniqueness: true
    votedQuestions:
      dataType: 'reference'
      referenceModelName: 'Question'
      many: true
    askedQuestions:
      dataType: 'reference'
      referenceModelName: 'Question'
      many: true
      reverseReferenceAttribute: 'sessionOwner'

module.exports = Session
