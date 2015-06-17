Property = require 'data/framework/properties/Property'

class HasManyForeignRelation extends Property

  isForeign: true

  constructor: (parent, name, config) ->
    super(parent, name, config)
    {@type, @index, @order} = config

  getSchema: ->
    @parent.constructor.get(@type)

module.exports = HasManyForeignRelation
