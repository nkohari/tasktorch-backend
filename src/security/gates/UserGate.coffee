_                                  = require 'lodash'
Gate                               = require 'security/framework/Gate'
GetAllActiveMembershipsByUserQuery = require 'data/queries/memberships/GetAllActiveMembershipsByUserQuery'
GetAllActiveMembershipsByOrgQuery  = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class UserGate extends Gate

  guards: 'User'

  constructor: (@database) ->

  getAccessList: (user, callback) ->
    query = new GetAllActiveMembershipsByUserQuery(user.id)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      orgids = _.pluck(result.memberships, 'org')
      return callback(null, [user.id]) unless orgids.length > 0
      query  = new GetAllActiveMembershipsByOrgQuery(orgids)
      @database.execute query, (err, result) =>
        return callback(err) if err?
        userids = _.uniq _.flatten _.pluck(result.memberships, 'user')
        return callback null, userids

module.exports = UserGate
