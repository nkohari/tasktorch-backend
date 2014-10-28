r = require 'rethinkdb'
_ = require 'lodash'
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
    @rql.run dbConnection, (err, result) =>
      return callback(err) if err?
      return callback(null, result) unless result.toArray?
      result.toArray (err, documents) =>
        return callback(err) if err?
        return callback(null, documents)

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
          return r.object(field, value)
      if relation.type == RelationType.HasMany
        @rql = @rql.merge (parent) ->
          index = relation.index ? 'id'
          value = r.table(schema.table).getAll(r.args(parent(field)), {index}).coerceTo('array')
          return r.object(field, value)
      if relation.type == RelationType.HasManyForeign
        @rql = @rql.merge (parent) ->
          index = relation.index ? 'id'
          value = r.table(schema.table).getAll(parent('id'), {index}).coerceTo('array')
          return r.object(field, value)

module.exports = Query
