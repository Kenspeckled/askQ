Base = require './Base.coffee'
ooRecordsInstanceMethods = require '../app/models/modules/ooRecordsInstanceMethods.coffee'
ooRecordsAjaxClassMethods = require '../app/models/modules/ooRecordsAjaxClassMethods.coffee'
class ObjectOrientedRecord extends Base
  constructor: (initialisedProps) ->
    _class = @constructor
    @beforeInitialise(initialisedProps) if @beforeInitialise
    if _.has(_class, 'allowedProps') and _.isObject(initialisedProps)
      if _.has(initialisedProps, 'id')
        this.id = initialisedProps.id
      @properties = {}
      for prop in _class.allowedProps
        this[prop] = initialisedProps[prop]
        @properties[prop] = initialisedProps[prop]
    @afterInitialise(initialisedProps) if @afterInitialise

  @extend ooRecordsAjaxClassMethods
  @include ooRecordsInstanceMethods

module.exports = ObjectOrientedRecord
