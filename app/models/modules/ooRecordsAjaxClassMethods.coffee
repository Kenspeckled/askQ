Promise = require 'promise'

httpRequest = (method, url, args, isJson) ->
  new Promise (resolve, reject) ->
    client = new XMLHttpRequest
    uri = url
    if args
      uri += '?'
      argcount = 0
      for key of args
        if args.hasOwnProperty(key)
          if argcount++
            uri += '&'
          uri += encodeURIComponent(key) + '=' + encodeURIComponent(args[key])
    client.open method, uri
    client.send()

    client.onload = ->
      if @status == 200
        if isJson
          resolve JSON.parse(@response)
        else
          resolve @response
      else
        reject @statusText

    client.onerror = ->
      reject @statusText

if typeof window == 'undefined' #window is not defined on the server
  url = ''
else
  url = window.location.href.replace(window.location.pathname, '').replace(window.location.search, '')

ajax =
  get: (path, args) ->
    httpRequest 'GET', url + '/' + path, args, true
  post: (path, args) ->
    httpRequest 'POST', url + '/' + path, args
  put: (path, args) ->
    httpRequest 'PUT', url + '/' + path, args
  delete: (path, args) ->
    httpRequest 'DELETE', url + '/' + path, args

AJAXClassMethods =

  moduleName: "AJAXClassMethods"

  all: ->
    ajax.get @indexPath

  find: ->
    ajax.get @showPath, {id: @id}

  findBy: (opts) ->
    ajax.get @showPath, opts

  where: (opts) ->
    ajax.get @indexPath, opts

  #create: (opts) ->
  #  ajax.post @createURL, opts

  #update: (id, opts) ->
  #  ajax.put @updateURL, opts

module.exports = AJAXClassMethods
