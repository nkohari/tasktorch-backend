async = require 'async'
r     = require 'rethinkdb'
_     = require 'lodash'
Event = require 'data/schemas/Event'

class Database

  @withConnection: (func) ->
    (args..., callback) ->
      @connectionPool.acquire (err, dbConnection) =>
        return callback(err) if err?
        cleanup = (results...) =>
          @connectionPool.release(dbConnection)
          callback.apply(null, results)
        func.apply this, _.flatten [dbConnection, args, cleanup]

  constructor: (@log, @connectionPool) ->

  execute: @withConnection (dbConnection, statement, callback) ->
    @log.debug(statement.rql.toString())
    statement.execute(dbConnection, callback)

  executeAll: (queries, callback) ->
    async.map queries, @execute.bind(this), callback

  recordEvent: @withConnection (dbConnection, event, callback) ->
    @log.inspect(event)
    rql = r.table(Event.table).insert(event)
    @log.debug(rql.toString())
    rql.run dbConnection, (err) =>
      return callback(err) if err?
      callback(null, event)

module.exports = Database
