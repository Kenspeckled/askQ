class Question extends ObjectOrientedRecord
  
  @vote: (questionId, voteDirection) ->
    @ajax.post '/api/question/'+questionId+'/vote/' + voteDirection

module.exports = Question
