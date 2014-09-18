r     = require 'rethinkdb'
Query = require './Query'

class SecondaryIndexQuery extends Query

  constructor: (type, @index, @value) ->
    super(type)

  buildStatement: ->
    r.table(@type.table)
      .getAll @value, {@index}
      .limit(1)

  execute: (conn, callback) ->
    statement = @getStatement()
    statement.run conn, (err, cursor) =>
      return callback(err) if err?
      cursor.toArray (err, records) =>
        cursor.close()
        return callback(err) if err?
        return callback(null, null) if records.length == 0
        callback(null, records[0])

module.exports = SecondaryIndexQuery
