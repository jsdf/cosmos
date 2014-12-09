assert = (value, message) ->
  unless value
    throw new Error("Assertion Failed: #{message}")

module.exports = assert
