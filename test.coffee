_            = require 'lodash'
util         = require 'util'
loadFiles    = require 'common/util/loadFiles'
Schema       = require 'data/framework/Schema'
RelationType = require 'data/framework/RelationType'

for name, type of loadFiles('src/data/schemas', __dirname)
  console.log "Registered #{name}"

inspect = (obj) ->
  console.log util.inspect(obj, null, 999)

class QueryResult

  constructor: (@schema, tree) ->
    @related = {}
    if _.isArray(tree)
      @[@schema.plural] = _.map tree, (item) => @_flatten(@schema, item)
      @_extract(@schema, item) for item in tree
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
          if _.isObject(value)
            result[key] = value.id
          else
            result[key] = value
        else
          if _.isArray(value) and value.length > 0
            if _.isObject(value[0])
              result[key] = _.pluck(value, 'id')
            else
              result[key] = value
          else
            result[key] = value
    return result

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

stack1 = 
  id: 'stack1'
  name: 'Inbox'
  team:
    id: 'team1'
    name: 'Team One'
    members: [{id: 'user1'}, {id: 'user2'}]

stack2 = 
  id: 'stack2'
  name: 'Derp'
  team:
    id: 'team2'
    name: 'Team Two'
    members: [{id: 'user1'}, {id: 'user2'}, {id: 'user3'}]

result = new QueryResult(Schema.get('Stack'), [stack1, stack2])
inspect _.omit(result, 'schema', '_flatten', '_extract')