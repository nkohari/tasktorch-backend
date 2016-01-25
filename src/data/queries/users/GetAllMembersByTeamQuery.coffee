r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Team  = require 'data/documents/Team'
User  = require 'data/documents/User'

class GetAllMembersByTeamQuery extends Query

  constructor: (teamid, options) ->
    super(User, options)

    @rql = r.table(Team.getSchema().table).get(teamid).do (team) =>
      r.branch(
        team('members').count().eq(0),
        [],
        r.table(@schema.table).getAll(r.args(team('members'))).coerceTo('array')
      )

module.exports = GetAllMembersByTeamQuery
