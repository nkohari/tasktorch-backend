_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class FileGate extends Gate

  guards: 'File'

  constructor: (@database) ->

  getAccessList: (file, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(file.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = FileGate
