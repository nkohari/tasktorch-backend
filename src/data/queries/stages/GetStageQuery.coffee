GetQuery = require 'data/framework/queries/GetQuery'
Stage    = require 'data/schemas/Stage'

class GetStageQuery extends GetQuery

  constructor: (id, options) ->
    super(Stage, id, options)

module.exports = GetStageQuery
