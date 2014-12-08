RelationType = require 'data/framework/RelationType'

CLASSES = {}
CLASSES[RelationType.HasOne] = require './HasOneExpansion'
CLASSES[RelationType.HasMany] = require './HasManyExpansion'
CLASSES[RelationType.HasManyForeign] = require './HasManyForeignExpansion'

createExpansion = (field, relation, children) ->
  klass = CLASSES[relation.type]
  throw new Error("Cannot create expansion for unknown relation type #{relation.type}") unless klass?
  return new klass(field, relation, children)

createPathTree = (paths) ->
  tree = {}
  for path in paths
    cursor = tree
    for token in path.split('.')
      cursor = cursor[token] ?= {}
  return tree

buildExpansionTree = (schema, paths) ->
  tree = {}
  for field, subpaths of paths
    relation = schema.relations[field]
    throw new Error("Schema #{schema.name} does not define a relation named #{field}") unless relation?
    children = buildExpansionTree(relation.getSchema(), subpaths)
    expansion = createExpansion(field, relation, children)
    tree[field] = expansion
  return tree

ExpansionTreeBuilder = {}
ExpansionTreeBuilder.build = (schema, paths) ->
  buildExpansionTree(schema, createPathTree(paths))

module.exports = ExpansionTreeBuilder
