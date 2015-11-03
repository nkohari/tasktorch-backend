_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class StackGate extends Gate

  guards: 'Stack'

  constructor: (@database) ->

  getAccessList: (stack, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(stack.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = StackGate
