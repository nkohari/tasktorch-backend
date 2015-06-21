Precondition      = require 'apps/api/framework/Precondition'
GetChecklistQuery = require 'data/queries/checklists/GetChecklistQuery'

class ResolveChecklist extends Precondition

  assign: 'checklist'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetChecklistQuery(request.params.checklistid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.checklist?
      reply(result.checklist)

module.exports = ResolveChecklist
