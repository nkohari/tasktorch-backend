Model = require '../framework/Model'

class TeamModel extends Model

  constructor: (baseUrl, team) ->
    super(team.id)
    @name = team.name
    @members = team.members
    @organization = team.organization.id
    @uri = "#{baseUrl}/organizations/#{@organization.id}/teams/#{@id}"

module.exports = TeamModel
