Model = require '../framework/Model'

class OrganizationModel extends Model

  getUri: (organization, request) ->
    "#{organization.id}"

  assignProperties: (organization) ->
    @name = organization.name
    @members = @many('UserModel', organization.members)

module.exports = OrganizationModel
