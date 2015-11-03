_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class OrgGate extends Gate

  guards: 'Org'

  constructor: (@database) ->

  getAccessList: (org, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(org.id)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = OrgGate
