r               = require 'rethinkdb'
Team            = require 'data/schemas/Team'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class RemoveMemberFromTeamStatement extends UpdateStatement

  constructor: (teamId, userId) ->
    patch = {members: r.row('members').setDifference([userId])}
    super(Team, teamId, patch)

module.exports = RemoveMemberFromTeamStatement
