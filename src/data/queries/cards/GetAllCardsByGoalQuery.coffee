r                  = require 'rethinkdb'
GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Card               = require 'data/documents/Card'

class GetAllCardsByKindQuery extends GetAllByIndexQuery

  constructor: (goalid, options) ->
    super(Card, {goals: goalid}, options)

module.exports = GetAllCardsByKindQuery
