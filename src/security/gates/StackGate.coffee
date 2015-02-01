_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class StackGate extends Gate

  guards: 'Stack'

  constructor: (@database) ->

  getAccessList: (stack, callback) ->
    query = new GetOrgQuery(stack.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = StackGate
