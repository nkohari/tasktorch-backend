_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class ActionGate extends Gate

  guards: 'Action'

  constructor: (@database) ->

  getAccessList: (action, callback) ->
    query = new GetOrgQuery(action.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = ActionGate
