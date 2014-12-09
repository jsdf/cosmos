Model = require 'ampersand-model'
{xhrToPromise} = require 'lib/xhr'

class RestModel extends Model
  sync: (method, model, options) ->
    context = {method, model, options}
    xhr = super
    xhrToPromise(xhr, context)

module.exports = RestModel