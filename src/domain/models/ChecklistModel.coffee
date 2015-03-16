Model = require 'domain/framework/Model'

class ChecklistModel extends Model

  constructor: (checklist) ->
    super(checklist)
    @org     = checklist.org
    @card    = checklist.card
    @stage   = checklist.stage
    @actions = checklist.actions

module.exports = ChecklistModel
