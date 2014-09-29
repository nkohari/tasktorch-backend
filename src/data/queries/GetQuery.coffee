r                 = require 'rethinkdb'
SingleResultQuery = require '../framework/queries/SingleResultQuery'

class GetQuery extends SingleResultQuery

  constructor: (type, @id, options) ->
    super(type, options)

  getStatement: ->
    r.table(@type.schema.table).get(@id).default(null)

module.exports = GetQuery
