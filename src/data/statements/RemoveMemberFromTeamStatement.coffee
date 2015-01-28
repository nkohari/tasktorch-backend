r               = require 'rethinkdb'
Team            = require 'data/schemas/Team'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class RemoveMemberFromTeamStatement extends UpdateStatement

  constructor: (teamid, userid) ->
    patch = {members: r.row('members').setDifference([userid])}
    super(Team, teamid, patch)

module.exports = RemoveMemberFromTeamStatement
