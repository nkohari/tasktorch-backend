Property = require './Property'

class HasOne extends Property

  get: ->
    @entity

  set: (data) ->
    entity    = @coerce(data)
    @isDirty  = (@previous isnt @entity) and !entity.equals(@previous)
    @previous = @entity
    @entity   = entity

  toJSON: (options) ->
    if @entity?
      if options.flatten
        @entity.id
      else
        @entity.toJSON(options)
    else
      @entity

module.exports = HasOne
