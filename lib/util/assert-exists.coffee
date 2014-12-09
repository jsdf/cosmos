assert = require './assert'

assertExists = (value) ->
  assert(value?, 'missing required value')

module.exports = assertExists
