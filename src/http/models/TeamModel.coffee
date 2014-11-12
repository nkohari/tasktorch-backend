Model = require 'http/framework/Model'

class TeamModel extends Model

  @describes: 'Team'
  @getUri: (id, request) -> "#{request.scope.organization.id}/teams/#{id}"

  load: (team) ->
    @name = team.name
    @organization = @one('organization', team.organization)
    @members = @many('members', team.members)

module.exports = TeamModel
