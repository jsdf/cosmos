# @cjsx React.DOM
React = require 'react'
Bs = require 'react-bootstrap'
marked = require 'marked'
Highlights = require 'highlights'

marked.setOptions
  highlight: (code, lang) ->
    new Highlights().highlightSync
      fileContents: code
      scopeName: lang

Page = React.createClass
  renderBody: ->
    body = @props.doc?.body
    if body?
      marked(body)
    else
      'no content'
  renderTags: ->
    <div>{@props.doc?.field_tags?.join(', ')}</div>
  render: ->
    <Bs.Grid>
      <Bs.Row className="show-grid">
        <Bs.Col xs={12}>
          <h1>{@props.name}</h1>
          <div dangerouslySetInnerHTML={__html: @renderBody()} />
          {@renderTags()}
        </Bs.Col>
      </Bs.Row>
    </Bs.Grid>

module.exports = Page
