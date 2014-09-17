_         = require 'lodash'
deepEqual = require 'deep-equal'
Property  = require './Property'

class Field extends Property

  get: ->
    @value

  set: (value) ->
    @isDirty  = !deepEqual(@previous, value)
    @previous = @value
    @value    = value

  toJSON: (options) ->
    if @value? and _.isFunction(@value.toJSON)
      @value.toJSON()
    else
      @value

module.exports = Field
