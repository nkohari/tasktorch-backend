_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class TeamGate extends Gate

  guards: 'Team'

  constructor: (@database) ->

  getAccessList: (team, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(team.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = TeamGate
