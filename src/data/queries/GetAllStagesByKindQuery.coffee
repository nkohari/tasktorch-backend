r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Stage = require 'data/schemas/Stage'

class GetAllStagesByKindQuery extends Query

  constructor: (kindId, options) ->
    super(Stage, options)
    @rql = r.table(Stage.table).getAll(kindId, {index: 'kind'}).orderBy('rank')

module.exports = GetAllStagesByKindQuery
