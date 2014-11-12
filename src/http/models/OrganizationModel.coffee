Model = require 'http/framework/Model'

class OrganizationModel extends Model

  @describes: 'Organization'
  @getUri: (id, request) -> "#{id}"

  load: (organization) ->
    @name = organization.name
    @members = @many('members', organization.members)

module.exports = OrganizationModel
