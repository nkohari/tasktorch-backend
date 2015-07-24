r                  = require 'rethinkdb'
GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Card               = require 'data/documents/Card'

class GetAllCardsByStageQuery extends GetAllByIndexQuery

  constructor: (stageid, options) ->
    super(Card, {stages: stageid}, options)

module.exports = GetAllCardsByStageQuery
