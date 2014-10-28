_ = require 'lodash'

class Model

  @create: (type, data, request) ->
    klass = require "../models/#{type}"
    new klass(data, request)

  constructor: (data, @request) ->
    if _.isString(data)
      @id = data
      @uri = "#{@request.baseUrl}/#{@getUri({id: data}, @request)}"
    else
      @id = data.id
      @uri = "#{@request.baseUrl}/#{@getUri(data, @request)}"
      @version = data.version
      @assignProperties(data)

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
