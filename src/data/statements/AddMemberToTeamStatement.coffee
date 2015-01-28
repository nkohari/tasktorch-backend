r               = require 'rethinkdb'
Team            = require 'data/schemas/Team'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class AddMemberToTeamStatement extends UpdateStatement

  constructor: (teamid, userid) ->
    patch = {members: r.row('members').setInsert(userid)}
    super(Team, teamid, patch)

module.exports = AddMemberToTeamStatement
