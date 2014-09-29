Event = require '../framework/Event'

class TeamAddedEvent extends Event

  constructor: (@organization, @team) ->
    super()

module.exports = TeamAddedEvent
