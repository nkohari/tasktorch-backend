_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class ChecklistGate extends Gate

  guards: 'Checklist'

  constructor: (@database) ->

  getAccessList: (stage, callback) ->
    query = new GetOrgQuery(stage.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = ChecklistGate
