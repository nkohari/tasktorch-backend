_ = require 'lodash'

class Property

  constructor: (@name, @type, @options = {}) ->
    @isDirty = false

  get: ->
    throw new Error("You must implement get() on #{@constructor.name}")

  set: (value) ->
    throw new Error("You must implement set() on #{@constructor.name}")

  toJSON: ->
    throw new Error("You must implement toJSON() on #{@constructor.name}")

  toDocument: ->
    throw new Error("You must implement toDocument() on #{@constructor.name}")

  coerce: (value) ->
    # TODO: Fix weird referencing
    Entities = require('../../entities')
    klass    = Entities[@type]
    unless value?             then return value
    if value instanceof klass then return value
    if _.isObject(value)      then return new klass(value)
    if _.isString(value)      then return klass.ref(value)
    throw new Error("Unknown value #{value} specified for property #{@name}")

module.exports = Property
