_     = require 'lodash'
Model = require 'domain/framework/Model'

class DocumentArrayResponse

  constructor: (doctype, documents) ->
    @[doctype.getSchema().getPlural()] = _.map documents, (doc) -> Model.create(doc)

module.exports = DocumentArrayResponse
