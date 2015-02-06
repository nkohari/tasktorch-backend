r               = require 'rethinkdb'
Team            = require 'data/documents/Team'
UpdateStatement = require 'data/statements/UpdateStatement'

class AddMemberToTeamStatement extends UpdateStatement

  constructor: (teamid, userid) ->
    patch = {members: r.row('members').setInsert(userid)}
    super(Team, teamid, patch)

module.exports = AddMemberToTeamStatement
