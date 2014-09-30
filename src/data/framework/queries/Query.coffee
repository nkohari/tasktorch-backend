_        = require 'lodash'
async    = require 'async'
r        = require 'rethinkdb'
Entities = require '../../entities'
HasOne   = require '../properties/HasOne'
HasMany  = require '../properties/HasMany'

class Query

  constructor: (@type, @options = {}) ->
    @expandProperties = []
    @expand(@options.expand) if @options.expand?

  getStatement: ->
    throw new Error("You must implement getStatement() on #{@constructor.name}")

  processResult: (result, callback) ->
    throw new Error("You must implement processResult() on #{@constructor.name}")

  expand: (properties...) ->
    @expandProperties = _.union @expandProperties, _.flatten(properties)

  execute: (conn, callback) ->
    query = @getStatement()
    enrichers = []

    for name in @expandProperties
      property = @type.schema.properties[name]
      schema   = Entities.getSchema(property.type)
      if property.kind is HasOne  then query = @addJoin(query, name, schema.table)
      if property.kind is HasMany then query = @addJoinMany(query, name, schema.table, 'id')

    query.run conn, (err, result) =>
      return callback(err) if err?
      async.map enrichers, ((func, next) => func(conn, result, next)), (err) =>
        return callback(err) if err?
        @processResult(result, callback)

  addJoin: (query, field, table) ->
    query.merge (parent) ->
      r.object(field, r.table(table).get(parent(field).default('__nonexistent__')).default(null))

  addJoinMany: (query, field, table, index) ->
    query.merge (parent) ->
      r.object(field, r.table(table).getAll(r.args(parent(field)), {index}).coerceTo('array'))

module.exports = Query
