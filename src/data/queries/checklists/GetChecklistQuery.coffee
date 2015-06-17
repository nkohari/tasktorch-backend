GetQuery  = require 'data/framework/queries/GetQuery'
Checklist = require 'data/documents/Checklist'

class GetChecklistQuery extends GetQuery

  constructor: (id, options) ->
    super(Checklist, id, options)

module.exports = GetChecklistQuery
