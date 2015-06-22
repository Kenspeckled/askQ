class QuestionBoard extends ObjectOrientedRecord
  @attributes =
    url:
      dataType: 'string'
      identifiable: true
      validates:
        presence: true
        uniqueness: true
    questions:
      dataType: 'reference'
      referenceModelName: 'Question'
      many: true

module.exports = QuestionBoard
