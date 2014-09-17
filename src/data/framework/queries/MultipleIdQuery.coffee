r                   = require 'rethinkdb'
MultipleResultQuery = require './MultipleResultQuery'

class MultipleIdQuery extends MultipleResultQuery

  constructor: (type, @ids) ->
    super(type)

  getStatement: ->
    r.table(@type.schema.table).getAll(r.args(@ids), {index: 'id'})

module.exports = MultipleIdQuery
