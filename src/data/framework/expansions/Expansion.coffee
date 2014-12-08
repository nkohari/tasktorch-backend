class Expansion

  constructor: (@field, @relation, @children) ->

  expand: (rql) ->
    for child, expansion of @children
      rql = rql.merge(expansion.getMergeFunction())
    return rql

module.exports = Expansion
