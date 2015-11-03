_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class ProfileGate extends Gate

  guards: 'Profile'

  constructor: (@database) ->

  getAccessList: (profile, callback) ->
    return callback(null, []) unless profile.org?
    query = new GetAllActiveMembershipsByOrgQuery(profile.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = ProfileGate
