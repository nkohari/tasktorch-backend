rethinkdb = require 'rethinkdb'
_         = require 'lodash'

class Database

  @withConnection: (func) ->
    (args..., callback) ->
      @connectionPool.acquire (err, conn) =>
        return callback(err) if err?
        cleanup = (results...) =>
          @connectionPool.release(conn)
          callback.apply(null, results)
        func.apply this, _.flatten [conn, args, cleanup]

  constructor: (@log, @connectionPool, @keyGenerator, @eventBus) ->

  execute: @withConnection (conn, query, callback) ->
    @log.debug query.rql.toString()
    query.execute(conn, callback)

  create: @withConnection (conn, entity, callback) ->
    entity.id = @keyGenerator.generate()
    {schema}  = entity.constructor
    record    = entity.toJSON {flatten: true}
    rethinkdb.table(schema.table).insert(record).run conn, (err, results) =>
      return callback(err) if err?
      entity.onCreated()
      entity.flushPendingEvents(@eventBus)
      callback()

  update: @withConnection (conn, entity, callback) ->
    {schema} = entity.constructor
    diff     = entity.toJSON {flatten: true, diff: true}
    rethinkdb.table(schema.table).get(entity.id).update(diff).run conn, (err, results) =>
      return callback(err) if err?
      entity.flushPendingEvents(@eventBus)
      callback()

  delete: @withConnection (conn, entity, callback) ->
    {schema} = entity.constructor
    rethinkdb.table(schema.table).get(entity.id).delete().run conn, (err, results) =>
      return callback(err) if err?
      entity.onDeleted()
      entity.flushPendingEvents(@eventBus)
      callback()

module.exports = Database
