Property = require 'data/framework/properties/Property'

class HasManyRelation extends Property

  constructor: (parent, name, config) ->
    super(parent, name, config)
    {@type, @foreign, @index, @order} = config

  getSchema: ->
    @parent.constructor.get(@type)

module.exports = HasManyRelation
