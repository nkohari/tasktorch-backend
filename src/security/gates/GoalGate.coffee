_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class GoalGate extends Gate

  guards: 'Goal'

  constructor: (@database) ->

  getAccessList: (goal, callback) ->
    query = new GetOrgQuery(goal.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = GoalGate
