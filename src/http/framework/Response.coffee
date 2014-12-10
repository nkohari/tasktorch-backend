_        = require 'lodash'
Model    = require './Model'
Document = require 'data/framework/Document'

class Response

  constructor: (data) ->
    if data instanceof Document
      @loadDocument(data)
    else
      @loadQueryResult(data)

  loadDocument: (document) ->
    schema = document.getSchema()
    @[schema.singular] = Model.create(document)

  loadQueryResult: (result) ->
    schema = result.schema
    if result[schema.plural] isnt undefined
      @[schema.plural] = _.map result[schema.plural], (item) -> Model.create(item)
    else
      if result[schema.singular] is null
        @[schema.singular] = null
      else
        @[schema.singular] = Model.create(result[schema.singular])

    unless _.isEmpty(result.related)
      @related = {}
      for kind, hash of result.related
        @related[kind] = _.object _.map hash, (item, id) -> [id, Model.create(item)]

module.exports = Response
