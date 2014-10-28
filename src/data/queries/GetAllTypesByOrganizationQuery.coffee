GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Type               = require 'data/schemas/Type'

class GetAllTypesByOrganizationQuery extends GetAllByIndexQuery

  constructor: (organizationId, options) ->
    super(Type, {organization: organizationId}, options)

module.exports = GetAllTypesByOrganizationQuery
