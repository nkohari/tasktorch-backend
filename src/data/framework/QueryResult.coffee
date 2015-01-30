_              = require 'lodash'
Field          = require 'data/framework/properties/Field'
HasOneRelation = require 'data/framework/properties/HasOneRelation'

class QueryResult

  constructor: (@doctype, tree) ->

    @related = {}
    schema   = @doctype.getSchema()

    if tree is null
      @[schema.getSingular()] = null
    else if _.isArray(tree)
      @[schema.getPlural()] = _.map tree, (item) => @_flattenAndCreateDocument(@doctype, schema, item)
      @_extractRelatedDocumentsFromSubtree(@doctype, schema, item) for item in tree
    else
      @[schema.getSingular()] = @_flattenAndCreateDocument(@doctype, schema, tree)
      @_extractRelatedDocumentsFromSubtree(@doctype, schema, tree)

  _extractRelatedDocumentsFromSubtree: (doctype, schema, tree) ->

    for field, property of schema.getProperties()
      continue if property instanceof Field

      relatedSchema  = property.getSchema()
      relatedDoctype = relatedSchema.getDoctype()

      extract = (obj) =>
        return unless _.isObject(obj)
        related = (@related[relatedSchema.getPlural()] ?= {})
        related[obj.id] = @_flattenAndCreateDocument(relatedDoctype, relatedSchema, obj)
        @_extractRelatedDocumentsFromSubtree(relatedDoctype, relatedSchema, obj)

      value = tree[field]
      if _.isArray(value)
        extract(item) for item in value
      else
        extract(value)

  _flattenAndCreateDocument: (doctype, schema, tree) ->

    result = {}
    for name, value of tree
      property = schema.getProperty(name)
      if property instanceof Field
        result[name] = value
      else if property instanceof HasOneRelation
        result[name] = if _.isObject(value) then value.id else value
      else if _.isArray(value) and value.length > 0
        result[name] = if _.isObject(value[0]) then _.pluck(value, 'id') else value
      else
        result[name] = value

    return new doctype(result)
    
module.exports = QueryResult
