r                   = require 'rethinkdb'
MultipleResultQuery = require '../framework/queries/MultipleResultQuery'

class MultiGetQuery extends MultipleResultQuery

  constructor: (type, @ids, options) ->
    super(type, options)

  getStatement: ->
    r.table(@type.schema.table).getAll(r.args(@ids), {index: 'id'})

module.exports = MultiGetQuery
