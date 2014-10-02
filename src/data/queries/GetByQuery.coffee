r            = require 'rethinkdb'
_            = require 'lodash'
ExpandoQuery = require '../framework/ExpandoQuery'

class GetByQuery extends ExpandoQuery

  constructor: (type, tuple, options) ->
    super(type, options)
    index = _.first _.keys(tuple)
    value = tuple[index]
    @rql  = r.table(type.schema.table).getAll(value, {index}).limit(1)

  processResult: (cursor, callback) ->
    cursor.toArray (err, records) =>
      return callback(err) if err?
      return callback(null, null) if records.length == 0
      callback null, new @type(records[0])

module.exports = GetByQuery
