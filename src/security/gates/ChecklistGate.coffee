_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class ChecklistGate extends Gate

  guards: 'Checklist'

  constructor: (@database) ->

  getAccessList: (checklist, callback) ->
    query = new GetOrgQuery(checklist.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = ChecklistGate
