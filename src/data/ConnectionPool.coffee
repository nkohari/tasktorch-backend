genpool   = require 'generic-pool'
rethinkdb = require 'rethinkdb'

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
    @log.debug "Opening connection ##{@pool.getPoolSize()} to RethinkDB at #{host}:#{port}/#{db}"
    rethinkdb.connect({host, port, db}, callback)

  destroy: (conn) ->
    @log.debug "Closing connection to RethinkDB"
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
