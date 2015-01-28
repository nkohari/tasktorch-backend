r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Team  = require 'data/schemas/Team'
User  = require 'data/schemas/User'

class GetAllMembersByTeamQuery extends Query

  constructor: (teamid, options) ->
    super(User, options)
    @rql = r.table(User.table).getAll(
      r.args(r.table(Team.table).get(teamid)('members'))
    ).coerceTo('array')

module.exports = GetAllMembersByTeamQuery
