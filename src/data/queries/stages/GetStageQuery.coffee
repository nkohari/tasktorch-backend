GetQuery = require 'data/framework/queries/GetQuery'
Stage    = require 'data/documents/Stage'

class GetStageQuery extends GetQuery

  constructor: (id, options) ->
    super(Stage, id, options)

module.exports = GetStageQuery
