class Context
  constructor: (path, state) ->
    hasQuery = _.contains(path, '?')
    if hasQuery
      queryIndex = path.indexOf('?')
      query = path.slice(queryIndex)
    @querystring = if hasQuery then decodeURIComponent(query.replace(/\+/g, ' ')) else ''
    @canonicalPath = path
    @path = path or '/'
    @title = document.title
    @state = state or {}
    @state.path = path
    @pathname = decodeURIComponent(if hasQuery then path.slice(0, queryIndex) else path)
    @params = {}
    @hash = ''
    if _.contains(@path, '#')
      parts = @path.split('#')
      @path = parts[0]
      @hash = decodeURIComponent(parts[1]) or ''
      @querystring = @querystring.split('#')[0]

  pushState: ->
    history.pushState @state, @title, @canonicalPath

  save: ->
    history.replaceState @state, @title, @canonicalPath

module.exports = Context
