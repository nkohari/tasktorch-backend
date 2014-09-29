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

    properties = _.map @expandProperties, (name) => @type.schema.properties[name]
    for property in properties
      if property.kind is HasOne  then query = @addJoin(query, property)
      if property.kind is HasMany then enrichers.push @createSubqueryFunction(property)

    query.run conn, (err, result) =>
      return callback(err) if err?
      async.map enrichers, ((func, next) => func(conn, result, next)), (err) =>
        return callback(err) if err?
        @processResult(result, callback)

  addJoin: (query, property) ->
    name   = property.name
    schema = Entities.getSchema(property.type)
    return query.merge (parent) ->
      r.object name, r.table(schema.table).get(parent(name).default('__does_not_exist__')).default(null)

  createSubqueryFunction: (property) ->
    throw new Error("You must implement createSubqueryFunction() on #{@constructor.name}")

module.exports = Query
