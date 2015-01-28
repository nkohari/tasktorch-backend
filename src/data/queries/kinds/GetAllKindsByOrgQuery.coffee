GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Kind               = require 'data/schemas/Kind'

class GetAllKindsByOrgQuery extends GetAllByIndexQuery

  constructor: (orgid, options) ->
    super(Kind, {org: orgid}, options)

module.exports = GetAllKindsByOrgQuery
