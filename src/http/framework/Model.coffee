_ = require 'lodash'

class Model

  constructor: (factory, document, request) ->
    @_factory  = factory
    @_request  = request
    @_document = document
    @id        = document.id
    @version   = document.version
    @uri       = "#{request.baseUrl}/#{@constructor.getUri(@id, request)}"
    @_related  = @createRelatedModels(document._related) if document._related?
    @load(document)

  load: (document) ->
    throw new Error("You must implement load() on #{@constructor.name}")

  createRelatedModels: (relatedDocuments) ->
    return _.object _.map relatedDocuments, (doc, key) =>
      [key, @_factory.create(doc, @_request)]

  ref: (field, id) ->
    schema   = @_document.getSchema()
    relation = schema.getRelation(field)
    @[field] = @_factory.ref(relation.getSchema(), id, @_request)

  refs: (field, ids) ->
    schema   = @_document.getSchema()
    relation = schema.getRelation(field)
    @[field] = _.map ids, (id) => @_factory.ref(relation.getSchema(), id, @_request)

  toJSON: ->
    _.omit(this, '_factory', '_request', '_document')

module.exports = Model
