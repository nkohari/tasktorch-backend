Model = require '../framework/Model'

class TeamModel extends Model

  getUri: (team, request) ->
    "#{request.scope.organization.id}/teams/#{team.id}"

  assignProperties: (team) ->
    @name = team.name
    @members = @many('UserModel', team.members)
    @organization = @one('OrganizationModel', team.organization)
    @stacks = @many('StackModel', team.stacks) if team.stacks?

module.exports = TeamModel
