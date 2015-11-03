_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class NoteGate extends Gate

  guards: 'Note'

  constructor: (@database) ->

  getAccessList: (note, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(note.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = NoteGate
