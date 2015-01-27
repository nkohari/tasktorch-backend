uuid         = require 'common/util/uuid'
ActionStatus = require 'domain/enums/ActionStatus'

class Action

  constructor: (orgId, cardId, stageId, text) ->
    @id     = uuid()
    @status = ActionStatus.NotStarted
    @org    = orgId
    @card   = cardId
    @stage  = stageId
    @text   = text ? null

module.exports = Action
