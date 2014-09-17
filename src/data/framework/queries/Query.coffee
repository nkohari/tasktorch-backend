_       = require 'lodash'
async   = require 'async'
r       = require 'rethinkdb'
HasOne  = require '../properties/HasOne'
HasMany = require '../properties/HasMany'

class Query

  constructor: (@type) ->
    @expandProperties = []

  getStatement: ->
    throw new Error("You must implement getStatement() on #{@constructor.name}")

  mapResult: (result) ->
    if result? then new @type(result) else null

  expand: (properties...) ->
    @expandProperties = _.union(@expandProperties, properties)

  execute: ->
    throw new Error("You must implement execute() on #{@constructor.name}")

  buildQuery: ->
    query     = @getStatement()
    enrichers = []

    properties = _.map @expandProperties, (name) => @type.schema.properties[name]
    _.each properties, (property) =>
      if property.kind is HasOne  then query = @addJoin(query, property)
      if property.kind is HasMany then enrichers.push @createSubqueryFunction(property)

    return {query, enrichers}

  runQuery: (conn, query, enrichers, callback) ->
    query.run conn, (err, result) =>
      return callback(err) if err?
      async.map enrichers, ((func, next) => func(conn, result, next)), (err) ->
        return callback(err) if err?
        callback(null, result)

  addJoin: (query, property) ->
    name  = property.name
    table = property.type.schema.table
    return query.eqJoin(name, r.table(table)).map (tuple) ->
      tuple('left').merge(r.object(name, tuple('right')))

  createSubqueryFunction: (property) ->
    throw new Error("You must implement createSubqueryFunction() on #{@constructor.name}")

module.exports = Query
