_         = require 'lodash'
loadFiles = require 'common/util/loadFiles'

class ModelFactory

  constructor: (@forge) ->
    @models = _.indexBy(loadFiles('models', __dirname), 'describes')

  create: (document, request) ->
    type = document.getSchema().name
    klass = @models[type]
    throw new Error("Don't know how to create a model for document of type #{type}") unless klass?
    return new klass(this, document, request)

  # TODO: The url generation stuff here is weird. It should probably move
  # to a UrlGenerator component or something like that.
  ref: (schema, id, request) ->
    klass = @models[schema.name]
    throw new Error("Don't know how to create a ref for property of type #{schema.name}") unless klass?
    return {
      id: id
      uri: "#{request.baseUrl}/#{klass.getUri(id, request)}"
    }

module.exports = ModelFactory
