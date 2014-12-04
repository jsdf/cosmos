fs = require 'fs'
path = require 'path'
browserifyAssets = require 'browserify-assets'

bundlePattern = /(.+)\.(\w+)$/
opts =
  extensions: ['.coffee']
  cacheFile: 'tmp/cache.json'
module.exports = (req, res, next) ->
  matches = bundlePattern.exec req.params.filename
  res.send(404) unless matches?
  [filenameInput, urlBundlePath, urlBundleExt] = matches
  bundlePath = path.resolve './client/', urlBundlePath

  b = browserifyAssets(opts)
  b.transform 'coffee-reactify'
  b.on 'log', (msg) ->
    console.log "asset-build: #{msg}"
  b.on 'update', (updated) ->
    if updated?.length
      console.log "asset-build changed files: #{updated.join(', ')}"
  b.add bundlePath

  switch urlBundleExt
    when 'css'
      b.on 'assetStream', (assetStream) ->
        # output css here
        assetStream.pipe res
      b.bundle().pipe fs.createWriteStream('tmp/bundle.css')
    when 'js'
      b.on 'assetStream', (assetStream) ->
        assetStream.pipe fs.createWriteStream('tmp/bundle.js')
      # output js here
      b.bundle().pipe res
    else
      next(new Error 'invalid extension')
  return
