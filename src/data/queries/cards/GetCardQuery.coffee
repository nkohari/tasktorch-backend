GetQuery = require 'data/framework/queries/GetQuery'
Card     = require 'data/documents/Card'

class GetCardQuery extends GetQuery

  constructor: (id, options) ->
    super(Card, id, options)

module.exports = GetCardQuery
