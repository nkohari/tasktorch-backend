Model = require 'http/framework/Model'

class TeamModel extends Model

  constructor: (team) ->
    super(team)
    @name         = team.name
    @organization = team.organization
    @members      = team.members

module.exports = TeamModel
