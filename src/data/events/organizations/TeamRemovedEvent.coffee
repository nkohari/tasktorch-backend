Event = require '../framework/Event'

class TeamRemovedEvent extends Event

  constructor: (@organization, @team) ->
    super()

module.exports = TeamRemovedEvent
