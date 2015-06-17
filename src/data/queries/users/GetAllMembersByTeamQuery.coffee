r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Team  = require 'data/documents/Team'
User  = require 'data/documents/User'

class GetAllMembersByTeamQuery extends Query

  constructor: (teamid, options) ->
    super(User, options)
    @rql = r.table(@schema.table).getAll(
      r.args(r.table(Team.getSchema().table).get(teamid)('members'))
    ).coerceTo('array')

module.exports = GetAllMembersByTeamQuery
