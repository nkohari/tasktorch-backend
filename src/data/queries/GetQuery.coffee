r            = require 'rethinkdb'
ExpandoQuery = require '../framework/ExpandoQuery'

class GetQuery extends ExpandoQuery

  constructor: (type, id, options) ->
    super(type, options)
    @rql = r.table(type.schema.table).get(id).default(null)

module.exports = GetQuery
