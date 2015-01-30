r     = require 'rethinkdb'
Query = require './Query'

class MultiGetQuery extends Query

  constructor: (doctype, ids, options) ->
    super(doctype, options)
    @rql = r.table(@schema.table).getAll(r.args(ids), {index: 'id'}).default([]).coerceTo('array')

module.exports = MultiGetQuery
