_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class InviteGate extends Gate

  guards: 'Invite'

  constructor: (@database) ->

  getAccessList: (invite, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(invite.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = InviteGate
