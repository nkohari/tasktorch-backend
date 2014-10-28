_ = require 'lodash'

class Relation

  constructor: (@parent, @name, spec) ->
    _.extend(this, spec)

  getSchema: ->
    @parent.constructor.get(@schema)

module.exports = Relation
