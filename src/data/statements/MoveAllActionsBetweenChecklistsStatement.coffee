_         = require 'lodash'
r         = require 'rethinkdb'
Checklist = require 'data/documents/Checklist'
Statement = require 'data/framework/Statement'

class MoveAllActionsBetweenChecklistsStatement extends Statement

  constructor: (fromStageId, toStageId) ->
    super(Checklist)

    table = Checklist.getSchema().table
    @rql = r.table(table).getAll(fromStageId, {index: 'stage'})
      .forEach (checklist) ->
        r.table(table).getAll(checklist('card'), {index: 'card'}).update(((item) ->
          r.branch(
            item('stage').eq(toStageId),
            {actions: item('actions').union(checklist('actions')), version: item('version').add(1), updated: r.now()},
            {}
          )), {returnChanges: true})

  run: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      return callback(response.first_error) if response.first_error?
      documents = _.map response.changes, (change) => new @doctype(change.new_val)
      callback(null, documents)

module.exports = MoveAllActionsBetweenChecklistsStatement
