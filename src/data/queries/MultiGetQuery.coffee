r            = require 'rethinkdb'
ExpandoQuery = require '../framework/ExpandoQuery'

class MultiGetQuery extends ExpandoQuery

  constructor: (type, ids, options) ->
    super(type, options)
    @rql = r.table(type.schema.table).getAll(r.args(ids), {index: 'id'}).default([])

module.exports = MultiGetQuery
