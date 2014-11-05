_ = require 'lodash'

class Document

  constructor: (schema, data) ->
    @_schema = schema
    @_related = @_createRelatedDocuments(data._related) if data._related?
    _.extend this, _.omit(data, '_related')

  toJSON: ->
    _.omit(this, _.functions(this), '_schema', '_related')

  getSchema: ->
    @_schema

  getRelated: (key) ->
    related = @_related?[key]
    throw new Error("No related document was loaded at #{key}") unless related?
    return related

  _createRelatedDocuments: (related) ->
    return _.object _.map related, (data, field) =>
      relation = @_schema.getRelation(field)
      if not data?
        value = null
      else if _.isArray(data)
        value = _.map data, (datum) => new Document(relation.getSchema(), datum)
      else
        value = new Document(relation.getSchema(), data)
      [field, value]
 
module.exports = Document
