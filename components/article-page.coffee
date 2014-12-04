# @cjsx React.DOM
React = require 'react'
Bs = require 'react-bootstrap'

Article = require './article'

ArticlePage = React.createClass
  renderTeasers: ->
    @props.docs.map (doc) ->
      <Article.Teaser key={doc.id} {...doc} />

  render: ->
    <div>
      <Bs.Grid>
        <Bs.Row>
          <Bs.Col xs={12}>
            <h1>{@props.title}</h1>
          </Bs.Col>
        </Bs.Row>
      </Bs.Grid>
      {@renderTeasers()}      
      <Bs.Grid>
        <Bs.Row>
          <Bs.Col xs={12}>
            <p>&copy; {@props.title} {new Date().getFullYear()}</p>
          </Bs.Col>
        </Bs.Row>
      </Bs.Grid>
    </div>

module.exports = ArticlePage
