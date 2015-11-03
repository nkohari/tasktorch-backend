_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class MembershipGate extends Gate

  guards: 'Membership'

  constructor: (@database) ->

  getAccessList: (membership, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(membership.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = MembershipGate
