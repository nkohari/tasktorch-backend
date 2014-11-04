r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Team  = require 'data/schemas/Team'
User  = require 'data/schemas/User'

class GetAllMembersOfTeamQuery extends Query

  constructor: (teamId, options) ->
    super(User, options)
    @rql = r.table(User.table).getAll(
      r.args(r.table(Team.table).get(teamId)('members'))
    )

module.exports = GetAllMembersOfTeamQuery
