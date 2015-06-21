_     = require 'lodash'
Model = require 'domain/framework/Model'

class DocumentResponse

  constructor: (document) ->
    @[document.getSchema().getSingular()] = Model.create(document)

module.exports = DocumentResponse
