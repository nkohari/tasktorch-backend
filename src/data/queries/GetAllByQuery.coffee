r            = require 'rethinkdb'
_            = require 'lodash'
ExpandoQuery = require '../framework/ExpandoQuery'

class GetAllByQuery extends ExpandoQuery

  constructor: (type, tuple, options) ->
    super(type, options)
    index = _.first _.keys(tuple)
    value = tuple[index]
    @rql  = r.table(type.schema.table).getAll(value, {index})

module.exports = GetAllByQuery
