_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class KindGate extends Gate

  guards: 'Kind'

  constructor: (@database) ->

  getAccessList: (kind, callback) ->
    return callback(null, []) unless kind.org?
    query = new GetOrgQuery(kind.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = KindGate
