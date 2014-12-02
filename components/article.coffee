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

trimAfterParagraph = (text, minChars) ->
  paragraphEndPattern = /\n\s*\n/g
  paragraphEndPattern.lastIndex = minChars
  paragraphEndMatch = paragraphEndPattern.exec(text)
  if paragraphEndMatch and paragraphEndMatch.index
    text.substring(0, paragraphEndMatch.index)
  else
    text

renderTags = (tags) ->
  if tags?.length
    <div>
      <strong>Tags:</strong> {tags.join(', ')}
    </div>

ArticleLayout = React.createClass
  render: ->
    <Bs.Grid>
      <Bs.Row>
        <Bs.Col xs={12}>
          {@props.children}
        </Bs.Col>
      </Bs.Row>
    </Bs.Grid>

Article = React.createClass
  renderBody: ->
    body = @props.doc?.body
    if body?
      marked(body)
    else
      'no content'

  render: ->
    <ArticleLayout>
      <h1>{@props.name}</h1>
      <div dangerouslySetInnerHTML={__html: @renderBody()} />
      {renderTags(@props.doc?.field_tags)}
    </ArticleLayout>

Article.Teaser = React.createClass
  getLink: -> @props.doc?.path or "/doc/#{@props.id}"

  renderBody: ->
    body = @props.doc?.body
    if body?
      marked(trimAfterParagraph(body, 300))
    else
      'no content'

  render: ->
    <ArticleLayout>
      <h2><a href={@getLink()}>{@props.name}</a></h2>
      <div dangerouslySetInnerHTML={__html: @renderBody()} />
      <a href="/doc/#{@props.id}">Read more &rarr;</a>
      {renderTags(@props.doc?.field_tags)}
    </ArticleLayout>

module.exports = Article
