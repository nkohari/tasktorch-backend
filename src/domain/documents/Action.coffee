uuid         = require 'common/util/uuid'
ActionStatus = require 'domain/enums/ActionStatus'

class Action

  constructor: (data) ->
    @id     = data.id     ? uuid()
    @status = data.status ? ActionStatus.NotStarted
    @org    = data.org
    @card   = data.card
    @stage  = data.stage
    @text   = data.text   ? null

module.exports = Action
