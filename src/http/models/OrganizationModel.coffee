Model = require '../framework/Model'

class OrganizationModel extends Model

  constructor: (organization) ->
    super(organization.id)
    @name = organization.name
    @members = organization.members

module.exports = OrganizationModel
