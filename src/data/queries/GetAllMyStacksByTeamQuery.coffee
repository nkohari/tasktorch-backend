r = require 'rethinkdb'

class GetAllMyStacksByTeamQuery

  constructor: (@userId) ->

  execute: (conn, callback) ->
    query = r.table('teams').getAll(@userId, {index: 'members'}).merge (team) ->
      {stacks: r.table('stacks').getAll(team('id'), {index: 'team'}).coerceTo('array')}
    query.run conn, (err, cursor) ->
      return callback err if err?
      cursor.toArray (err, results) ->
        return callback err if err?
        cursor.close()
        callback(null, results)

module.exports = GetAllMyStacksByTeamQuery
