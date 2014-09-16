r                   = require 'rethinkdb'
MultipleResultQuery = require './MultipleResultQuery'

class MultipleIdQuery extends MultipleResultQuery

  constructor: (@type, @ids) ->
    super()

  getStatement: ->
    r.table(@type.schema.table).getAll(r.args(@ids), {index: 'id'})

  mapResult: (item) ->
    new @type(item)

module.exports = MultipleIdQuery
