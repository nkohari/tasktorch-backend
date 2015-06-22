Subscription = require 'data/framework/Subscription'

class Database

  constructor: (@connectionPool) ->

  execute: (query, callback) ->
    @connectionPool.acquire (err, conn) =>
      return callback(err) if err?
      conn.execute query, (err, result) =>
        return callback(err) if err?
        @connectionPool.release(conn)
        callback(null, result)

  subscribe: (doctype, callback) ->
    subscription = new Subscription(@connectionPool, doctype)
    subscription.start (err) =>
      return callback(err) if err?
      callback(null, subscription)

module.exports = Database
