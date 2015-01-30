Property = require 'data/framework/properties/Property'

class HasManyForeignRelation extends Property

  constructor: (parent, name, config) ->
    super(parent, name, config)
    {@type, @index, @order} = config

  getSchema: ->
    @parent.constructor.get(@type)

module.exports = HasManyForeignRelation
