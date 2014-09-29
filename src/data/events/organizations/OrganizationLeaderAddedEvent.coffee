Event = require '../framework/Event'

class OrganizationLeaderAddedEvent extends Event

  constructor: (@organization, @user) ->
    super()

module.exports = OrganizationLeaderAddedEvent
