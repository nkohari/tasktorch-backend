_           = require 'lodash'
Field       = require './properties/Field'
HasOne      = require './properties/HasOne'
HasMany     = require './properties/HasMany'
DataType    = require '../enums/DataType'

propertyDeclarator = (kind) ->
  return (name, type, options = {}) ->
    schema = (@schema ?= {})
    (schema.properties ?= {})[name] = {kind, name, type, options}
    Object.defineProperty @prototype, name,
      get: -> @properties[name].get()
      set: (value) -> @properties[name].set(value)

class Entity

  @DataType = DataType

  @table: (name) ->
    (@schema ?= {}).table = name

  @field:   propertyDeclarator(Field)
  @hasOne:  propertyDeclarator(HasOne)
  @hasMany: propertyDeclarator(HasMany)

  @ref: (id) ->
    entity = new this {id}
    entity._isRef = true
    return entity

  Object.defineProperty @prototype, 'isDirty',
    get: -> _.any @properties, (p) -> p.isDirty

  Object.defineProperty @prototype, 'isRef',
    get: -> @_isRef

  constructor: (data = {}) ->
    @properties = {}
    for name, spec of @constructor.schema.properties
      @properties[name] = property = new spec.kind(name, spec.type, spec.options)
      property.set(data[name] ? spec.default)
      property.isDirty = false

  merge: (data) ->
    for key, value of data
      unless @properties[key]?
        throw new Error("Unknown property #{name} for #{@constructor.name}")
      @properties[key].set(value)

  equals: (other) ->
    other instanceof @constructor and other.id == @id

  toJSON: (options = {}) ->

    if @isRef
      return if options.flatten then @id else {id: @id}

    if options.diff
      properties = _.select @properties, (p) -> p.isDirty
    else
      properties = _.values @properties

    data = {_type: @constructor.name.toLowerCase()}
    for property in properties
      value = property.toJSON({flatten: options.flatten})
      data[property.name] = value unless value is undefined

    return data

module.exports = Entity
