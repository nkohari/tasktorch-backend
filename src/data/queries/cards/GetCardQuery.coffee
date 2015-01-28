GetQuery = require 'data/framework/queries/GetQuery'
Card     = require 'data/schemas/Card'

class GetCardQuery extends GetQuery

  constructor: (id, options) ->
    super(Card, id, options)

module.exports = GetCardQuery
