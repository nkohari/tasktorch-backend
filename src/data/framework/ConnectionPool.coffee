genpool    = require 'generic-pool'
rethinkdb  = require 'rethinkdb'
retry      = require 'retry'
Connection = require './Connection'

class ConnectionPool

  constructor: (@app, @config, @log) ->
    @count = 0
    @pool = genpool.Pool
      name:     @name
      max:      @config.rethinkdb.maxConnections
      create:   @create.bind(this)
      destroy:  @destroy.bind(this)
      validate: @validate.bind(this)
    @app.on 'stop', => @shutdown()

  create: (callback) ->

    id = ++@count
    {host, port, db, authKey, cert, maxAttempts, backoffFactor} = @config.rethinkdb

    operation = retry.operation {
      retries: (maxAttempts - 1) if maxAttempts?
      factor:  backoffFactor
    }

    options = {host, port, db, authKey}
    options.ssl = {ca: cert} if cert?

    operation.attempt (attempt) =>
      @log.debug "[db:#{id}] Opening connection to #{host}:#{port}/#{db} (attempt #{attempt}/#{maxAttempts})"
      rethinkdb.connect options, (err, conn) =>
        # Retry the connection a number of times before giving up.
        return if operation.retry(err)
        return callback(operation.mainError()) if err?
        @log.debug "[db:#{id}] Connection established, pool size = #{@pool.getPoolSize()}"
        callback null, new Connection(id, @log, conn)

  destroy: (conn) ->
    @log.debug "[db:#{conn.id}] Closing connection, pool size = #{@pool.getPoolSize()}"
    conn.close()

  validate: (conn) ->
    conn.isOpen and not conn.isClosing

  acquire: (callback) ->
    @pool.acquire(callback)

  release: (callback) ->
    @pool.release(callback)

  shutdown: ->
    @log.info 'Flushing connection pool'
    @pool.drain =>
      @pool.destroyAllNow()

module.exports = ConnectionPool
