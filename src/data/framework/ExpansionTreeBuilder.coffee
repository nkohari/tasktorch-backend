# TODO: This is pretty janky, but it works. Revisit to reorganize.

CLASSES = {}
CLASSES['HasOneRelation']         = require './expansions/HasOneExpansion'
CLASSES['HasManyRelation']        = require './expansions/HasManyExpansion'
CLASSES['HasManyForeignRelation'] = require './expansions/HasManyForeignExpansion'

createExpansion = (field, property, children) ->
  klass = CLASSES[property.constructor.name]
  unless klass?
    throw new Error("Cannot create expansion for property of type #{property.constructor.name}")
  return new klass(field, property, children)

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
    property = schema.getProperty(field)
    unless property?
      throw new Error("Schema #{schema.name} does not define a property named #{field}")
    children  = buildExpansionTree(property.getSchema(), subpaths)
    expansion = createExpansion(field, property, children)
    tree[field] = expansion
  return tree

ExpansionTreeBuilder = {}
ExpansionTreeBuilder.build = (schema, paths) ->
  buildExpansionTree(schema, createPathTree(paths))

module.exports = ExpansionTreeBuilder
