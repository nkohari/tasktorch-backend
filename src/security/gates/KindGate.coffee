_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class KindGate extends Gate

  guards: 'Kind'

  constructor: (@database) ->

  getAccessList: (kind, callback) ->
    return callback(null, []) unless kind.org?
    query = new GetAllActiveMembershipsByOrgQuery(kind.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = KindGate
