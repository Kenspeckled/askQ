pathToRegexp = require 'path-to-regexp'
class Route
  constructor: (path, options) ->
    options = options or {}
    @path = (if path == '*' then '(.*)' else path)
    @method = 'GET'
    @regexp = pathToRegexp(@path, @keys = [], options.sensitive, options.strict)

  middleware: (fn) ->
    self = this
    (ctx, next) ->
      if self.match(ctx.path, ctx.params)
        return fn(ctx, next)
      next()
      return

  match: (path, params) ->
    keys = @keys
    qsIndex = path.indexOf('?')
    pathname = if ~qsIndex then path.slice(0, qsIndex) else path
    m = @regexp.exec(decodeURIComponent(pathname))
    if !m
      return false
    i = 1
    len = m.length
    while i < len
      key = keys[i - 1]
      val = decodeURIComponent(m[i])
      if val != undefined or !hasOwnProperty.call(params, key.name)
        params[key.name] = val
      ++i

module.exports = Route
