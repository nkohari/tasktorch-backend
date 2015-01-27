r               = require 'rethinkdb'
Team            = require 'data/schemas/Team'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class AddMemberToTeamStatement extends UpdateStatement

  constructor: (teamId, userId) ->
    patch = {members: r.row('members').setInsert(userId)}
    super(Team, teamId, patch)

module.exports = AddMemberToTeamStatement
