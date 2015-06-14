RookClientObject = require 'rook/lib/models/ClientObject'
class Question extends RookClientObject
  
  @vote: (questionId, voteDirection) ->
    @ajax.post '/api/question/'+questionId+'/vote/' + voteDirection

module.exports = Question
