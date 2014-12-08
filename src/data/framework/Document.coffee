_ = require 'lodash'

class Document

  constructor: (schema, data) ->
    @_schema = schema
    _.extend(this, data)

  getSchema: ->
    @_schema
 
module.exports = Document
