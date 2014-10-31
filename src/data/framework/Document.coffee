_ = require 'lodash'

class Document

  constructor: (schema, data) ->
    @_schema = schema
    @_related = @_createRelatedDocuments(data._related) if data._related?
    _.extend this, _.omit(data, '_related')

  getSchema: ->
    @_schema

  getRelated: (key) ->
    related = @_related?[key]
    throw new Error("No related document was loaded at #{key}") unless related?
    return related

  _createRelatedDocuments: (related) ->
    return _.object _.map related, (data, name) =>
      return null unless data?
      relation = @_schema.getRelation(name)
      [name, new Document(relation.getSchema(), data)]
 
module.exports = Document
