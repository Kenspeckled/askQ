clearDataCacheAfterEventLoop = ->
  self = this
  process.nextTick ->
    self.dataCache = {}

class DataCache
  constructor: (obj) ->
    @dataCache = {}
    @setObject(obj) if obj

  setObject: (obj) ->
    for k in Object.keys(obj)
      @dataCache[k] = obj[k]

  # set: (key, value) -> #Don't think this is needed
  #   @dataCache[key] = value
  #   value

  get: (key) ->
    if @dataCache.hasOwnProperty(key)
      return @dataCache[key]
    else
      return false

  setCacheFromContext: (context) ->
    if context.dataCache
      @dataCache = context.dataCache

  assignToContext: (context) ->
    context.dataCache = {}
    if @dataCache
      for k in Object.keys(@dataCache)
        context.dataCache[k] = @dataCache[k]
    clearDataCacheAfterEventLoop.call(this)


module.exports = DataCache
