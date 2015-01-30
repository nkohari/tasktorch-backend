GetQuery = require 'data/framework/queries/GetQuery'
Org      = require 'data/documents/Org'

class GetOrgQuery extends GetQuery

  constructor: (id, options) ->
    super(Org, id, options)

module.exports = GetOrgQuery
