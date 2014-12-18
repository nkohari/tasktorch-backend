_            = require 'lodash'
RelationType = require 'data/RelationType'
Document     = require 'data/Document'

class QueryResult

  constructor: (@schema, tree) ->
    @related = {}
    if _.isArray(tree)
      @[@schema.plural] = _.map tree, (item) => @_flatten(@schema, item)
      @_extract(@schema, item) for item in tree
    else
      if tree is null
        @[@schema.singular] = null
      else
        @[@schema.singular] = @_flatten(@schema, tree)
        @_extract(@schema, tree)

  _flatten: (schema, tree) ->
    result = {}
    for key, value of tree
      relation = schema.relations[key]
      if not relation?
        result[key] = value
      else
        if relation.type == RelationType.HasOne
          result[key] = if _.isObject(value) then value.id else value
        else
          if _.isArray(value) and value.length > 0
            result[key] = if _.isObject(value[0]) then _.pluck(value, 'id') else value
          else
            result[key] = value
    return new Document(schema, result)

  _extract: (schema, tree) ->
    for field, relation of schema.relations
      relatedSchema = relation.getSchema()
      extractSubtree = (data) =>
        related = (@related[relatedSchema.plural] ?= {})
        related[data.id] = @_flatten(relatedSchema, data)
        @_extract(relatedSchema, data)
      if relation.type == RelationType.HasOne
        extractSubtree(tree[field]) if _.isObject(tree[field])
      else if _.isArray(tree[field])
        for item in tree[field]
          extractSubtree(item) if _.isObject(item)

module.exports = QueryResult
