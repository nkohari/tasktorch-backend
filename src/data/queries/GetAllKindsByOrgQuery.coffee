GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Kind               = require 'data/schemas/Kind'

class GetAllKindsByOrgQuery extends GetAllByIndexQuery

  constructor: (orgId, options) ->
    super(Kind, {org: orgId}, options)

module.exports = GetAllKindsByOrgQuery
