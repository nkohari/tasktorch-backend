genpool    = require 'generic-pool'
rethinkdb  = require 'rethinkdb'
Connection = require './Connection'

class ConnectionPool

  constructor: (@app, @config, @log) ->
    @pool = genpool.Pool
      name:    @name
      max:     @config.rethinkdb.maxConnections
      create:  @create.bind(this)
      destroy: @destroy.bind(this)
    @app.on 'stop', => @shutdown()

  create: (callback) ->
    {host, port, db} = @config.rethinkdb
    id = @pool.getPoolSize()
    @log.debug "[db:#{id}] Opening connection to #{host}:#{port}/#{db}"
    rethinkdb.connect {host, port, db}, (err, conn) =>
      return callback(err) if err?
      callback null, new Connection(id, @log, conn)

  destroy: (conn) ->
    @log.debug "[db:#{conn.id}] Closing connection"
    conn.close()

  acquire: (callback) ->
    @pool.acquire(callback)

  release: (callback) ->
    @pool.release(callback)

  shutdown: ->
    @log.info 'Flushing RethinkDB connection pool'
    @pool.drain =>
      @pool.destroyAllNow()

module.exports = ConnectionPool
