_        = require 'lodash'
Property = require './Property'
Set      = require 'collections/set'

class HasMany extends Property

  get: ->
    @entities

  set: (items) ->
    @entities.removeRangeChangeListener(this) if @entities?
    @isDirty = true

    items = _.map items, (item) => @coerce(item)
    equal = (a, b) -> a.equals(b)
    hash  = (obj)  -> obj.id

    @entities = new Set(items, equal, hash)
    @entities.addRangeChangeListener(this)

  toJSON: (options) ->
    if options.flatten
      @entities.map (item) => item.id
    else
      @entities.map (item) => item.toJSON(options)

  handleRangeChange: (plus, minus, index) ->
    @isDirty = true

module.exports = HasMany
