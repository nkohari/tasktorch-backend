Property = require 'data/framework/properties/Property'

class HasOneRelation extends Property

  constructor: (parent, name, config) ->
    super(parent, name, config)
    {@type} = config

  getSchema: ->
    @parent.constructor.get(@type)

module.exports = HasOneRelation
