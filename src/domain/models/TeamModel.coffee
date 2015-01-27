Model = require 'domain/Model'

class TeamModel extends Model

  constructor: (team) ->
    super(team)
    @name    = team.name
    @org     = team.org
    @members = team.members
    @leaders = team.leaders

module.exports = TeamModel
