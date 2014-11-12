GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Kind               = require 'data/schemas/Kind'

class GetAllKindsByOrganizationQuery extends GetAllByIndexQuery

  constructor: (organizationId, options) ->
    super(Kind, {organization: organizationId}, options)

module.exports = GetAllKindsByOrganizationQuery
