r     = require 'rethinkdb'
_     = require 'lodash'
Query = require './Query'

class GetAllByListQuery extends Query

  constructor: (schema, parentSchema, parentId, property, options) ->
    super(schema, options)
    @rql = r.table(parentSchema.table).get(parentId)(property).default([]).map((id) ->
      r.table(schema.table).get(id)
    ).default([])

module.exports = GetAllByListQuery
