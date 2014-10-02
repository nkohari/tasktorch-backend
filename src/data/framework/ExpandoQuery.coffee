r        = require 'rethinkdb'
_        = require 'lodash'
Entities = require '../entities'
HasOne   = require './properties/HasOne'
HasMany  = require './properties/HasMany'
Query    = require './Query'

class ExpandoQuery extends Query

  constructor: (@type, options) ->
    super(options)
    @expandos = []
    @expand(@options.expand) if @options.expand?

  expand: (properties...) ->
    @expandos = _.union @expandos, _.flatten(properties)

  with: (expandoField, table) ->
    @rql = @rql.merge (parent) ->
      r.object(expandoField, r.table(table).get(parent(expandoField).default('__nonexistent__')).default(null))

  withMany: (expandoField, table, foreignIndex) ->
    @rql = @rql.merge (parent) ->
      r.object(expandoField, r.table(table).getAll(r.args(parent(expandoField)), {index: foreignIndex}).coerceTo('array'))

  withManyForeign: (expandoField, table, joinField, foreignIndex) ->
    @rql = @rql.merge (parent) ->
      r.object(expandoField, r.table(table).getAll(parent(joinField), {index: foreignIndex}).coerceTo('array'))

  beforeExecute: ->
    for name in @expandos
      property = @type.schema.properties[name]
      schema   = Entities.getSchema(property.type)
      if property.kind is HasOne
        @with(name, schema.table)
      else if property.kind is HasMany
        if property.options.foreign?
          @withManyForeign(name, schema.table, 'id', property.options.foreign)
        else
          @withMany(name, schema.table, 'id')

  processResultItem: (item) ->
    return new @type(item)

module.exports = ExpandoQuery
