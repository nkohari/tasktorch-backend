Model = require '../framework/Model'

class OrganizationModel extends Model

  constructor: (organization) ->
    super(organization.id)
    @name = organization.name
    @users = organization.users

module.exports = OrganizationModel
