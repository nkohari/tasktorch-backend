r     = require 'rethinkdb'
Query = require './Query'

class GetQuery extends Query

  constructor: (schema, id, options) ->
    super(schema, options)
    @rql = r.table(@schema.table).get(id).default(null)

module.exports = GetQuery
