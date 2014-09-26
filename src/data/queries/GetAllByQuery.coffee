r = require 'rethinkdb'
_ = require 'lodash'
MultipleResultQuery = require '../framework/queries/MultipleResultQuery'

class GetAllByQuery extends MultipleResultQuery

  constructor: (type, tuple, options) ->
    super(type, options)
    @index = _.first _.keys(tuple)
    @value = tuple[@index]

  getStatement: ->
    r.table(@type.schema.table).getAll(@value, {@index})

module.exports = GetAllByQuery
