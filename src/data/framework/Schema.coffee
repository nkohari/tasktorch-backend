_                      = require 'lodash'
Field                  = require './properties/Field'
HasOneRelation         = require './properties/HasOneRelation'
HasManyRelation        = require './properties/HasManyRelation'
HasManyForeignRelation = require './properties/HasManyForeignRelation'

class Schema

  @schemas: {}

  @get: (name) ->
    schema = Schema.schemas[name]
    unless schema?
      throw new Error("Cannot resolve document schema named #{name}")
    return schema

  @getAll: ->
    _.values(Schema.schemas)

  @getOrCreate: (doctype) ->
    schema = Schema.schemas[doctype.name] ?= new this(doctype)
    return schema

  constructor: (@doctype) ->
    @name = doctype.name
    @properties = {}

  addField: (name, config) ->
    @properties[name] = new Field(this, name, config)

  addHasOne: (name, config) ->
    @properties[name] = new HasOneRelation(this, name, config)

  addHasMany: (name, config) ->
    @properties[name] = new HasManyRelation(this, name, config)

  addHasManyForeign: (name, config) ->
    @properties[name] = new HasManyForeignRelation(this, name, config)

  setNaming: ({singular, plural}) ->
    @naming = {singular, plural}

  getDoctype: ->
    @doctype

  getProperties: ->
    @properties

  getProperty: (name) ->
    unless @properties[name]?
      throw new Error("Schema #{@name} does not have a property named #{name}")
    @properties[name]
    
  getSingular: ->
    @naming.singular

  getPlural: ->
    @naming.plural

module.exports = Schema
