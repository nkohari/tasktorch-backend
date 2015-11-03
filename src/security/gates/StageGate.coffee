_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class StageGate extends Gate

  guards: 'Stage'

  constructor: (@database) ->

  getAccessList: (stage, callback) ->
    return callback(null, []) unless stage.org?
    query = new GetAllActiveMembershipsByOrgQuery(stage.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = StageGate
