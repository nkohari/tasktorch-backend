_        = require 'lodash'
Property = require './Property'

class HasMany extends Property

  get: ->
    @entities

  set: (items) ->
    @isDirty = true
    @entities = _.map items, (item) => @coerce(item)

  toJSON: (options) ->
    if options.flatten
      _.pluck(@entities, 'id')
    else
      _.map @entities, (item) -> item.toJSON(options)

  handleRangeChange: (plus, minus, index) ->
    @isDirty = true

module.exports = HasMany
