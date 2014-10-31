Model = require 'http/framework/Model'

class TeamModel extends Model

  @describes: 'Team'
  @getUri: (id, request) -> "#{request.scope.organization.id}/teams/#{id}"

  load: (team) ->
    @name = team.name
    @organization = @ref('organization', team.organization)
    @members = @ref('members', team.members)

module.exports = TeamModel
