MultiGetQuery = require 'data/framework/queries/MultiGetQuery'
Card          = require 'data/documents/Card'

class MultiGetCardsQuery extends MultiGetQuery

  constructor: (ids, options) ->
    super(Card, ids, options)

module.exports = MultiGetCardsQuery
