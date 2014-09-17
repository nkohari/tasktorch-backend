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

  constructor: (@connectionPool, @keyGenerator) ->

  execute: @withConnection (conn, query, callback) ->
    query.execute(conn, callback)

  save: (entity, callback) ->
    if entity.id?
      return @update(entity, callback)
    else
      return @create(entity, callback)

  create: @withConnection (conn, entity, callback) ->
    entity.id = @keyGenerator.generate()
    record    = entity.toJSON()
    rethinkdb.table(entity.table).insert(record).run conn, (err, results) =>
      return callback(err) if err?
      callback()

  update: @withConnection (conn, entity, callback) ->
    diff = entity.diff()
    rethinkdb.table(entity.table).get(entity.id).update(diff).run conn, (err, results) =>
      return callback(err) if err?
      callback()

  delete: @withConnection (conn, entity, callback) ->
    rethinkdb.table(entity.table).get(entity.id).delete().run conn, (err, results) =>
      return callback(err) if err?
      callback()

module.exports = Database
