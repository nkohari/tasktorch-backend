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

  beforeExecute: ->
    for name in @expandos
      property = @type.schema.properties[name]
      schema   = Entities.getSchema(property.type)
      if property.kind is HasOne  then @with(name, schema.table)
      if property.kind is HasMany then @withMany(name, schema.table, 'id')

  processResult: (result) ->
    return new @type(result)

module.exports = ExpandoQuery
