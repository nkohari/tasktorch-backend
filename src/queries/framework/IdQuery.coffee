r                 = require 'rethinkdb'
SingleResultQuery = require './SingleResultQuery'

class IdQuery extends SingleResultQuery

  constructor: (@type, @id) ->
    super()

  getStatement: ->
    r.table(@type.schema.table).getAll(r.args(@id), {index: 'id'})

  mapResult: (item) ->
    new @type(item)

module.exports = IdQuery
