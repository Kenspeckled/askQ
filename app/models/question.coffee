class Question extends ObjectOrientedRecord
  @showPath = 'api/question/'+@id
  @createPath = 'api/question/new'
  @updatePath = 'api/question/'+@id+'/update'
  @attributes =
    question:
      dataType: 'string'
      validates:
        presence: true
        uniqueness: true
    questionBoard:
      dataType: 'association'
      many: false
      # preloadModel: Question
    votes:
      dataType: 'integer'
    flags:
      dataType: 'integer'

module.exports = Question
