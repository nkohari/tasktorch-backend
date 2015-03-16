r                  = require 'rethinkdb'
GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Card               = require 'data/documents/Card'

class GetAllCardsByKindQuery extends GetAllByIndexQuery

  constructor: (kindid, options) ->
    super(Card, {kind: kindid}, options)

module.exports = GetAllCardsByKindQuery
