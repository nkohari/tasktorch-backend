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

  Object.defineProperty @prototype, 'id',
    get: -> @_id
    set: (value) ->
      throw new Error("#{@constructor.name} already has an id (#{id})") if @_id?
      @_id = value

  Object.defineProperty @prototype, 'version',
    get: -> @_version

  Object.defineProperty @prototype, 'events',
    get: -> _.clone(@_events)

  Object.defineProperty @prototype, 'isDirty',
    get: -> _.any @properties, (p) -> p.isDirty

  Object.defineProperty @prototype, 'isRef',
    get: -> @_isRef

  constructor: (data = {}) ->
    @_id           = data.id      if data.id?
    @_version      = data.version ? 0
    @_events       = data.events  ? []
    @pendingEvents = []
    @properties    = {}
    for name, spec of @constructor.schema.properties
      @properties[name] = property = new spec.kind(name, spec.type, spec.options)
      property.set(data[name] ? spec.default)
      property.isDirty = false

  equals: (other) ->
    other instanceof @constructor and other.id == @id

  onCreated: ->
    
  onDeleted: ->

  announce: (event) ->
    @pendingEvents.push(event)

  flushPendingEvents: (eventBus) ->
    return unless @pendingEvents.length > 0
    eventBus.publish(@pendingEvents)
    @_events = @_events.concat(@pendingEvents)
    @pendingEvents = []

  incrementVersion: ->
    @_version++

  toJSON: (options = {}) ->

    if @isRef
      return if options.flatten then @id else {@id}

    properties = _.select @properties, (p) -> not p.options.foreign?

    if options.diff
      properties = _.select properties, (p) -> p.isDirty

    data = {@id, @version}
    for property in properties
      value = property.toJSON({flatten: options.flatten})
      data[property.name] = value unless value is undefined

    return data

module.exports = Entity
