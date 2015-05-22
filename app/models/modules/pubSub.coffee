PubSub = {
  moduleName: "PubSub"

  broadcast: (ev, data) ->
    @_callbacks = {} if !@hasOwnProperty('_callbacks')
    _callbackList = @_callbacks[ev]
    return this if !@hasOwnProperty('_callbacks') || !_callbackList
    _callbackList.forEach (fn) =>
      fn.call(this, data)
    return this

  listen: (ev, fn) ->
    @_callbacks = {} if !@hasOwnProperty('_callbacks')
    (@_callbacks[ev] || @_callbacks[ev] = []).push fn
    return this
}
module.exports = PubSub
