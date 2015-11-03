_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class GoalGate extends Gate

  guards: 'Goal'

  constructor: (@database) ->

  getAccessList: (goal, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(goal.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = GoalGate
