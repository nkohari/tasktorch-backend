GetQuery     = require 'data/framework/queries/GetQuery'
Organization = require 'data/schemas/Organization'

class GetOrganizationQuery extends GetQuery

  constructor: (id, options) ->
    super(Organization, id, options)

module.exports = GetOrganizationQuery
