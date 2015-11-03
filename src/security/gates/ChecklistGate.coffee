_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class ChecklistGate extends Gate

  guards: 'Checklist'

  constructor: (@database) ->

  getAccessList: (checklist, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(checklist.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = ChecklistGate
