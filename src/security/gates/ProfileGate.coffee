_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class ProfileGate extends Gate

  guards: 'Profile'

  constructor: (@database) ->

  getAccessList: (profile, callback) ->
    return callback(null, []) unless profile.org?
    query = new GetOrgQuery(profile.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = ProfileGate
