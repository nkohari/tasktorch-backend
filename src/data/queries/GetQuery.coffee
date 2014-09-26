r                 = require 'rethinkdb'
SingleResultQuery = require '../framework/queries/SingleResultQuery'

class IdQuery extends SingleResultQuery

  constructor: (type, @id, options) ->
    super(type, options)

  getStatement: ->
    r.table(@type.schema.table).get(@id).default(null)

module.exports = IdQuery
