r     = require 'rethinkdb'
_     = require 'lodash'
Query = require './Query'

class GetByIndexQuery extends Query

  constructor: (doctype, tuple, options) ->
    super(doctype, options)
    index = _.first _.keys(tuple)
    value = tuple[index]
    @rql  = r.table(@schema.table).getAll(value, {index}).default([]).limit(1).coerceTo('array')

  preprocessResult: (result, callback) ->
    result.toArray (err, items) =>
      return callback(err) if err?
      if items.length == 0
        callback(null, null)
      else
        callback(null, items[0])

module.exports = GetByIndexQuery
