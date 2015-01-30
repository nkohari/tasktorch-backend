r                 = require 'rethinkdb'
GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Kind              = require 'data/documents/Kind'
Stage             = require 'data/documents/Stage'

class GetAllStagesByKindQuery extends GetAllByListQuery

  constructor: (kindid, options) ->
    super(Stage, Kind, kindid, 'stages', options)

module.exports = GetAllStagesByKindQuery
