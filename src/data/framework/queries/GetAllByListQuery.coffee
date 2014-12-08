r     = require 'rethinkdb'
_     = require 'lodash'
Query = require './Query'

class GetAllByListQuery extends Query

  constructor: (schema, parentSchema, parentId, property, options) ->
    super(schema, options)
    # TODO: Worried about the performance of this -- can we change it to use getAll() instead?
    @rql = r.table(parentSchema.table).get(parentId)(property).default([]).map((id) ->
      r.table(schema.table).get(id)
    ).default([])

module.exports = GetAllByListQuery
