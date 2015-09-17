_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class StageGate extends Gate

  guards: 'Stage'

  constructor: (@database) ->

  getAccessList: (stage, callback) ->
    return callback(null, []) unless stage.org?
    query = new GetOrgQuery(stage.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = StageGate
