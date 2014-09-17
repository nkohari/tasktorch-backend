r                 = require 'rethinkdb'
SingleResultQuery = require './SingleResultQuery'

class IdQuery extends SingleResultQuery

  constructor: (type, @id) ->
    super(type)

  getStatement: ->
    r.table(@type.schema.table).getAll(r.args([@id]), {index: 'id'})

module.exports = IdQuery
