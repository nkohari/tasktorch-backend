Precondition      = require 'http/framework/Precondition'
GetChecklistQuery = require 'data/queries/checklists/GetChecklistQuery'

class ResolveChecklistArgument extends Precondition

  assign: 'checklist'

  constructor: (@database) ->

  execute: (request, reply) ->
    checklistid = request.payload.checklist
    query = new GetChecklistQuery(checklistid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such checklist #{checklistid}") unless result.checklist?
      reply(result.checklist)

module.exports = ResolveChecklistArgument
