_ = require 'lodash'

class Model

  @create: (type, entity, request) ->
    klass = require "../models/#{type}"
    new klass(entity, request)

  constructor: (entity, @request) ->
    @id  = entity.id
    @uri = "#{@request.baseUrl}/#{@getUri(entity, request)}"
    @assignProperties(entity) unless entity.isRef

  getUri: (entity, request) ->
    throw new Error("You must implement getUri() on #{@constructor.name}")

  assignProperties: (entity) ->
    throw new Error("You must implement assignProperties() on #{@constructor.name}")

  toJSON: ->
    _.omit(this, 'request')

  one: (type, entity) ->
    return undefined unless entity?
    Model.create(type, entity, @request)

  many: (type, entities) ->
    _.map entities, (entity) => Model.create(type, entity, @request)

module.exports = Model
