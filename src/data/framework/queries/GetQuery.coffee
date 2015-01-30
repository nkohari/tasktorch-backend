r     = require 'rethinkdb'
Query = require './Query'

class GetQuery extends Query

  constructor: (doctype, id, options) ->
    super(doctype, options)
    @rql = r.table(@schema.table).get(id).default(null)

module.exports = GetQuery
