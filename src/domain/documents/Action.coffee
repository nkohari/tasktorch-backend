uuid         = require 'common/util/uuid'
ActionStatus = require 'domain/enums/ActionStatus'

class Action

  constructor: (organizationId, cardId, stageId, text) ->
    @id           = uuid()
    @status       = ActionStatus.NotStarted
    @organization = organizationId
    @card         = cardId
    @stage        = stageId
    @text         = text ? null

module.exports = Action
