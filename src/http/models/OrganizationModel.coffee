Model = require 'http/framework/Model'

class OrganizationModel extends Model

  constructor: (organization) ->
    super(organization)
    @name    = organization.name
    @members = organization.members

module.exports = OrganizationModel
