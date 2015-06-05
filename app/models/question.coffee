class Question extends BaseClass
  # @addQuestionPath = '/api/add-question'
  # @votePath = '/api/vote'
  # @flagPath = '/api/flag'
  # @indexPath = '/api/all-questions'
  @attributes =
    text:
      dataType: 'string'
      validates:
        presence: true
        uniqueness: true
    session:
      dataType: 'association'
      many: false
      # preloadModel: Question
    votes:
      dataType: 'integer'
    flags:
      dataType: 'integer'

module.exports = Question
