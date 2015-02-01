_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class TeamGate extends Gate

  guards: 'Team'

  constructor: (@database) ->

  getAccessList: (team, callback) ->
    query = new GetOrgQuery(team.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = TeamGate
