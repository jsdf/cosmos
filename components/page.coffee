# @cjsx React.DOM
React = require 'react'
marked = require 'marked'
Highlights = require 'highlights'

marked.setOptions
  highlight: (code, lang) ->
    new Highlights().highlightSync
      fileContents: code
      scopeName: lang

Page = React.createClass
  renderBody: ->
    body = @props.doc?.body?['und']?[0]?['value']
    if body?
      marked(body)
    else
      'no content'
  render: ->
    <div>
      <h1>{@props.name}</h1>
      <div dangerouslySetInnerHTML={__html: @renderBody()} />
    </div>

module.exports = Page
