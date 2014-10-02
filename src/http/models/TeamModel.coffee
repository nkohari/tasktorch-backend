Model = require '../framework/Model'

class TeamModel extends Model

  constructor: (baseUrl, team) ->
    super(team.id)
    @name = team.name
    @members = team.members
    @organization = team.organization.id
    @uri = "#{baseUrl}/#{@organization.id}/teams/#{@id}"
    @stacks = team.stacks if team.stacks?

module.exports = TeamModel
