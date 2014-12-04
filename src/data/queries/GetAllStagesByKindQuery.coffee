r                 = require 'rethinkdb'
GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Kind              = require 'data/schemas/Kind'
Stage             = require 'data/schemas/Stage'

class GetAllStagesByKindQuery extends GetAllByListQuery

  constructor: (kindId, options) ->
    super(Stage, Kind, kindId, 'stages', options)

module.exports = GetAllStagesByKindQuery
