class Question extends ObjectOrientedRecord
  @showPath = 'api/question/show'
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
    votes:
      dataType: 'integer'
    flags:
      dataType: 'integer'

  @vote: (questionId, voteDirection) ->
    @ajax.post '/api/question/'+questionId+'/vote/' + voteDirection

module.exports = Question
