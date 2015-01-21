r                 = require 'rethinkdb'
GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Card              = require 'data/schemas/Card'
Stack             = require 'data/schemas/Stack'

class GetAllCardsByStackQuery extends GetAllByListQuery

  constructor: (stackId, options) ->
    super(Card, Stack, stackId, 'cards', options)

module.exports = GetAllCardsByStackQuery
