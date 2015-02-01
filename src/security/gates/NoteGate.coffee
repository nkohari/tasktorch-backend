_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class NoteGate extends Gate

  guards: 'Note'

  constructor: (@database) ->

  getAccessList: (note, callback) ->
    query = new GetOrgQuery(note.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = NoteGate
