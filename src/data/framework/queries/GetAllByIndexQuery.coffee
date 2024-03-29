r     = require 'rethinkdb'
_     = require 'lodash'
Query = require './Query'

class GetAllByIndexQuery extends Query

  constructor: (doctype, tuple, options) ->
    super(doctype, options)
    index = _.first _.keys(tuple)
    value = tuple[index]
    @rql  = r.table(@schema.table).getAll(value, {index}).default([]).coerceTo('array')

module.exports = GetAllByIndexQuery
