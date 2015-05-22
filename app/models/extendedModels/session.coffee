ClientSession = require 'models/session.coffee'
ooRecordsORMClassMethods = require 'models/extendedModels/modules/ooRecordsORMClassMethods.coffee'
class Session extends ClientSession
  @extend ooRecordsORMClassMethods

module.exports = Session
