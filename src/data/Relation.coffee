_ = require 'lodash'

class Relation

  constructor: (@parent, @name, spec) ->
    _.extend(this, spec)

  getSchema: ->
    console.log(@parent) if @schema is undefined
    @parent.constructor.get(@schema)

module.exports = Relation
