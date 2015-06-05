class Question extends BaseClass
  # @addQuestionPath = '/api/add-question'
  # @votePath = '/api/vote'
  # @flagPath = '/api/flag'
  # @indexPath = '/api/all-questions'
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
