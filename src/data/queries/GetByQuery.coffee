r = require 'rethinkdb'
_ = require 'lodash'
MultipleResultQuery = require '../framework/queries/MultipleResultQuery'

class GetByQuery extends MultipleResultQuery

  constructor: (type, tuple, options) ->
    super(type, options)
    @index = _.first _.keys(tuple)
    @value = tuple[@index]

  getStatement: ->
    r.table(@type.schema.table).getAll(@value, {@index}).limit(1)

  processResult: (cursor, callback) ->
    cursor.toArray (err, records) =>
      return callback(err) if err?
      cursor.close()
      return callback(null, null) if records.length == 0
      callback null, new @type(records[0])

module.exports = GetByQuery
