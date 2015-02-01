_                       = require 'lodash'
Gate                    = require 'security/framework/Gate'
GetAllOrgsByMemberQuery = require 'data/queries/orgs/GetAllOrgsByMemberQuery'

class UserGate extends Gate

  guards: 'User'

  constructor: (@database) ->

  getAccessList: (user, callback) ->
    query = new GetAllOrgsByMemberQuery(user.id)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      userids = _.uniq _.flatten _.pluck(result.orgs, 'members')
      return callback null, userids

module.exports = UserGate
