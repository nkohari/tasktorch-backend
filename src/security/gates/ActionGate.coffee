_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class ActionGate extends Gate

  guards: 'Action'

  constructor: (@database) ->

  getAccessList: (action, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(action.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = ActionGate
