r               = require 'rethinkdb'
Team            = require 'data/documents/Team'
UpdateStatement = require 'data/statements/UpdateStatement'

class RemoveMemberFromTeamStatement extends UpdateStatement

  constructor: (teamid, userid) ->
    patch = {
      leaders: r.row('leaders').setDifference([userid])
      members: r.row('members').setDifference([userid])
    }
    super(Team, teamid, patch)

module.exports = RemoveMemberFromTeamStatement
