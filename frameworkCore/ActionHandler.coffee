Base = require './Base.coffee'
publishSubscribe = require '../app/models/modules/pubSub.coffee'

class ActionHandler extends Base
  @extend publishSubscribe

  # Takes an object and sets the listners on each property to the value of that property
  # i.e @registerListenersOn({ actionName: function })
  @registerListenersOn = (actionObj) ->
    throw new Error('Arguments not an object') if actionObj.constructor != Object
    for action of actionObj
      ActionHandler.listen action, actionObj[action]


module.exports = ActionHandler
