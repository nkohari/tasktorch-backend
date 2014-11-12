r            = require 'rethinkdb'
_            = require 'lodash'
Document     = require '../Document'
RelationType = require '../RelationType'

class Query

  @requiredFields: ['id', 'version']

  constructor: (@schema, @options = {}) ->
    @expansions = []
    @pluck(@options.pluck)   if @options.pluck?
    @expand(@options.expand) if @options.expand?

  pluck: (fields...) ->
    @fields = _.flatten(fields)

  expand: (fields...) ->
    @expansions = @expansions.concat _.flatten(fields)

  execute: (dbConnection, callback) ->
    @_processExpansions() if @expansions?
    @_processPluck() if @fields?
    console.log(@rql.toString())
    @rql.run dbConnection, (err, result) =>
      return callback(err) if err?
      @processResult(result, callback)

  processResult: (result, callback) ->
    return callback(null, null) unless result?
    return callback(null, new Document(@schema, result)) unless result.toArray?
    result.toArray (err, items) =>
      return callback(err) if err?
      if @options.firstResult
        callback null, new Document(@schema, items[0])
      else
        callback null, _.map items, (item) => new Document(@schema, item)

  _processPluck: ->
    @rql = @rql.pluck Query.requiredFields.concat(@fields)

  _processExpansions: ->
    for field in @expansions
      relation = @schema.getRelation(field)
      schema   = relation.getSchema()
      if relation.type == RelationType.HasOne
        @rql = @rql.merge (parent) ->
          foreignKey = parent(field).default('__nonexistent__')
          value = r.table(schema.table).get(foreignKey).default(null)
          return {_related: parent('_related').default({}).merge(r.object(field, value))}
      if relation.type == RelationType.HasMany
        @rql = @rql.merge (parent) ->
          index = relation.index ? 'id'
          value = r.table(schema.table).getAll(r.args(parent(field)), {index}).coerceTo('array')
          return {_related: parent('_related').default({}).merge(r.object(field, value))}
      if relation.type == RelationType.HasManyForeign
        @rql = @rql.merge (parent) ->
          index = relation.index ? 'id'
          value = r.table(schema.table).getAll(parent('id'), {index}).coerceTo('array')
          return {_related: parent('_related').default({}).merge(r.object(field, value))}

module.exports = Query
