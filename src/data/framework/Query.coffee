_ = require 'lodash'
r = require 'rethinkdb'

class Query

  constructor: (@options = {}) ->

  with: (field, table) ->
    @rql = @rql.merge (parent) ->
      r.object(field, r.table(table).get(parent(field).default('__nonexistent__')).default(null))

  withMany: (field, table, index) ->
    @rql = @rql.merge (parent) ->
      r.object(field, r.table(table).getAll(r.args(parent(field)), {index}).coerceTo('array'))

  execute: (conn, callback) ->
    @beforeExecute()
    @rql.run conn, (err, result) =>
      return callback(err) if err?
      return callback(null, @processResult(result)) unless result.toArray?
      result.toArray (err, results) =>
        return callback(err) if err?
        callback null, _.map results, (r) => @processResult(r)

  beforeExecute: ->

  processResult: (result) ->
    return result

module.exports = Query
