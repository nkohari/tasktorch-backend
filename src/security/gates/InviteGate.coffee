_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class InviteGate extends Gate

  guards: 'Invite'

  constructor: (@database) ->

  getAccessList: (invite, callback) ->
    query = new GetOrgQuery(invite.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = InviteGate
