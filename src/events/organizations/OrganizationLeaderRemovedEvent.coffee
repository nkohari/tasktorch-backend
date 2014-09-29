Event = require '../framework/Event'

class OrganizationLeaderRemovedEvent extends Event

  constructor: (@organization, @user) ->
    super()

module.exports = OrganizationLeaderRemovedEvent
