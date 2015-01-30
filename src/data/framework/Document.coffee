_              = require 'lodash'
uuid           = require 'common/util/uuid'
DocumentStatus = require 'data/enums/DocumentStatus'
Schema         = require './Schema'

class Document

  @table: (name) ->
    Schema.getOrCreate(this).table = name

  @naming: (config) ->
    Schema.getOrCreate(this).setNaming(config)

  @field: (name, config = {}) ->
    Schema.getOrCreate(this).addField(name, config)

  @hasOne: (name, type, config = {}) ->
    Schema.getOrCreate(this).addHasOne(name, type, config)

  @hasMany: (name, type, config = {}) ->
    Schema.getOrCreate(this).addHasMany(name, type, config)

  @hasManyForeign: (name, type, config = {}) ->
    Schema.getOrCreate(this).addHasManyForeign(name, type, config)

  @getSchema: ->
    Schema.get(@name)

  constructor: (data = {}) ->

    properties = Schema.get(@constructor.name).getProperties()
    unknowns   = _.difference _.keys(data), _.keys(properties)
    if unknowns.length > 0
      throw new Error("Unknown properties assigned to #{@constructor.name} document: #{unknowns.join(', ')}")

    for name, property of properties
      @[name] = data[name] ? property.default

  getSchema: ->
    Schema.get(@constructor.name)

module.exports = Document
