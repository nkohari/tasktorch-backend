r                 = require 'rethinkdb'
GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Card              = require 'data/documents/Card'
Stack             = require 'data/documents/Stack'

class GetAllCardsByStackQuery extends GetAllByListQuery

  constructor: (stackid, options) ->
    super(Card, Stack, stackid, 'cards', options)

module.exports = GetAllCardsByStackQuery
