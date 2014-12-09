jQuery = require 'jquery'
Promise = require 'bluebird'

# some handy helpers for wrapping jquery ajax with real promises and typed errors

isXHR = (obj) -> obj.status? and obj.statusText? and obj.getResponseHeader?

isRequestError = (err) -> err.name is 'RequestError'

# an xhr specific error object with extra properties
# check for it using the isRequestError function
RequestError = (xhr, context) ->
  response = try JSON.parse(xhr.responseText)
  err = new Error response?.error or 'Request error'
  err.name = 'RequestError'
  err.xhr = xhr
  err.status = xhr.status
  err.statusText = xhr.statusText
  err.response = response
  err.context = context
  err

xhrToPromise = (xhr, context) ->
  Promise
    .resolve(xhr)
    .catch isXHR, (xhr) ->
      Promise.reject RequestError(xhr, context)

# wrappers for jQuery methods, which return promises
getJSON = ->
  xhrToPromise(jQuery.getJSON(arguments...))
get = ->
  xhrToPromise(jQuery.get(arguments...))
post = ->
  xhrToPromise(jQuery.post(arguments...))
ajax = ->
  xhrToPromise(jQuery.ajax(arguments...))
getScript = ->
  xhrToPromise(jQuery.getScript(arguments...))

module.exports = {
  RequestError, 
  isXHR,
  isRequestError,
  xhrToPromise,
  getJSON,
  get,
  post,
  ajax,
  getScript,
}
