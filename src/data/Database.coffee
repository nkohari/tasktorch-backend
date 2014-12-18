class Database

  constructor: (@connectionPool) ->

  execute: (query, callback) ->
    @connectionPool.acquire (err, conn) =>
      return callback(err) if err?
      query.execute conn, (err, result) =>
        return callback(err) if err?
        @connectionPool.release(conn)
        callback(null, result)

module.exports = Database
