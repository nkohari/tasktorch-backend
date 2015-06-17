GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Action            = require 'data/documents/Action'
Checklist         = require 'data/documents/Checklist'

class GetAllActionsByChecklistQuery extends GetAllByListQuery

  constructor: (checklistid, options) ->
    super(Action, Checklist, checklistid, 'actions', options)

module.exports = GetAllActionsByChecklistQuery
