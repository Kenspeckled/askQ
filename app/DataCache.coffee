
class DataCache
  constructor: (obj) ->
    @data = {}
    @setObject(obj) if obj

  setObject: (obj) ->
    for k in Object.keys(obj)
      @data[k] = obj[k]

  get: (key) ->
    if @data.hasOwnProperty(key)
      return @data[key]
    else
      return false

  clear: ->
    process.nextTick => 
      @data = {}

  pluckProperties: (properties) ->
    returnObj = {}
    for propKey in properties
      if @data.hasOwnProperty(propKey)
        returnObj[propKey] = @data[propKey]
      else
        return false
    returnObj



module.exports = DataCache
