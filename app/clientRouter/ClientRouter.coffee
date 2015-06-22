# Best bits and adaptions of http://visionmedia.github.io/page.js/
Context = require './Context.coffee'
Route = require './Route.coffee'
class ClientRouter
  @sameOrigin = sameOrigin
  @getCallbacks = []
  @leaveCallbacks = []
  @current = ''

  if _.isUndefined(window)
    raise new Error "window is undefined"
  else
    location = window.history.location or window.location

  running = null
  prevContext = null

  onpopstate = (e) ->
    if e.state
      path = e.state.path
      ClientRouter.replace(path, e.state)
    else
      ClientRouter.show(location.pathname + location.hash, undefined, false)
    return

  nearestLinkFromClick = (e) ->
    el = e.target
    while el and 'A' != el.nodeName
      el = el.parentNode
    el

  sameOrigin = (href) ->
    origin = location.protocol + '//' + location.hostname
    if location.port
      origin += ':' + location.port
    href and 0 == href.indexOf(origin)

  onclick = (e) ->
    modifierKey = e.metaKey or e.ctrlKey or e.shiftKey
    return if !e.which or modifierKey or e.defaultPrevented
    el = nearestLinkFromClick(e)
    return if !el or 'A' != el.nodeName
    link = el.getAttribute('href')
    return if link == '#'
    return if el.pathname == location.pathname 
    return if link and link.indexOf('mailto:') > -1 or el.target or !sameOrigin(el.href)
    path = el.pathname + el.search + (el.hash or '')
    e.preventDefault()
    ClientRouter.show(path)

  unhandled = (ctx) ->
    return if ctx.handled
    current = location.pathname + location.search
    return if current == ctx.canonicalPath
    ClientRouter.stop()
    ctx.handled = false
    location.href = ctx.canonicalPath

  @get = (path, fn, args...) ->
    if _.isFunction(fn)
      route = new Route(path)
      _callbacks = @getCallbacks
      for c in [fn, args...]
        _callbacks.push route.middleware(c)
    else if fn and _.isString(fn)
      @redirect(path, fn)
    else if fn and _.isString(fn.path)
      @show(path, fn)
    else
      @start(path)

  @onLeave = (path, fn, args...) ->
    if _.isFunction(path)
      return @onLeave('*', path)
    route = new Route(path)
    _leaveCallbacks = @leaveCallbacks
    for func in [fn, args...]
      _leaveCallbacks.push route.middleware(func)

  @start = (options) ->
    options = options or {}
    return if running
    running = true
    window.addEventListener 'load', (->
      setTimeout (->
        window.addEventListener 'popstate', onpopstate, false
        return
      ), 0
      return
    ), false
    window.addEventListener 'click', onclick, false
    window.addEventListener 'touchstart', onclick, false
    setTimeout =>
      url = location.pathname + location.search + location.hash
      @replace(url, null, true)
    , 0

  @stop = ->
    return if !running
    @current = ''
    running = false
    window.removeEventListener 'click', onclick, false
    window.removeEventListener 'popstate', onpopstate, false

  @show = (path, state, push) ->
    ctx = new Context(path, state)
    @current = ctx.path
    @dispatch ctx
    if ctx.handled != false and push != false
      ctx.pushState()
    ctx

  @redirect = (from, to) ->
    if _.isString(from) and _.isString(to)
      @get from, (e) ->
        setTimeout (->
          @replace to
          return
        ), 0

  @replace = (path, state, init) ->
    ctx = new Context(path, state)
    @current = ctx.path
    #ctx.init = init
    ctx.save() # save before dispatching, which may redirect
    @dispatch ctx
    ctx

  @dispatch = (ctx) ->
    prev = prevContext
    getCallbackCounter = 0
    leaveCallbackCounter = 0
    nextLeaveCallback = =>
      fn = @leaveCallbacks[leaveCallbackCounter]
      return nextGetCallback() if !fn
      leaveCallbackCounter++
      fn.call(prev, nextLeaveCallback)
    nextGetCallback = =>
      fn = @getCallbacks[getCallbackCounter]
      if ctx.path != @current
        ctx.handled = false
        return
      return unhandled(ctx) if !fn
      getCallbackCounter++
      fn(ctx, nextGetCallback)
    prevContext = ctx
    if prev
      nextLeaveCallback()
    else
      nextGetCallback()


module.exports = ClientRouter
