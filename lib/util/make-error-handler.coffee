makeErrorHandler = (req, res, next) ->
  (err) -> req.app.get('errorHandler')(err, req, res, next)

module.exports = makeErrorHandler
