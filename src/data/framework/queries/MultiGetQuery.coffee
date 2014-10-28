r     = require 'rethinkdb'
Query = require './Query'

class MultiGetQuery extends Query

  constructor: (schema, ids, options) ->
    super(schema, options)
    @rql = r.table(@schema.table).getAll(r.args(ids), {index: 'id'}).default([])

module.exports = MultiGetQuery
