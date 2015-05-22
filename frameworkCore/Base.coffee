publishSubscribe = require '../app/models/modules/pubSub.coffee'
class Base
  constructor: (initialisedProps) ->
    _class = @constructor
    @beforeInitialise(initialisedProps) if @beforeInitialise
    if _.has(_class, 'allowedProps') and _.isObject(initialisedProps)
      for prop in _class.allowedProps
        this[prop] = initialisedProps[prop]
    @afterInitialise(initialisedProps) if @afterInitialise

  @extend = (args...) ->
    _class = this
    args.forEach (module) ->
      if module.constructor != Object
        throw new Error('Arguments not an object or a list of objects')
      if module.moduleInitialise
        initialiser = module.moduleInitialise.bind(_class)
        initialiser()
      for prop, value of module
        _class[prop] = value unless _.includes(['moduleName', 'moduleInitialise'], prop)
      _class.extendedModules = [] if !_class.extendedModules
      _class.extendedModules.push(module.moduleName) if !module.hasOwnProperty('moduleName')

  @include = (args...) ->
    _class = this
    args.forEach (module) ->
      if module.constructor != Object
        throw new Error('Arguments not an object or a list of objects')
      if module.moduleInitialise
        initialiser = module.moduleInitialise.bind(_class)
        initialiser()
      for prop,value of module
        _class.prototype[prop] = value unless _.includes(['moduleName', 'moduleInitialise'], prop)
      _class.includedModules = [] if !_class.includedModules
      _class.includedModules.push(module.moduleName) if !module.hasOwnProperty('moduleName')


Base.extend publishSubscribe

module.exports = Base

