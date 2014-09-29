Event = require '../framework/Event'

class UserJoinedOrganizationEvent extends Event

  constructor: (@organization, @user) ->
    super()

module.exports = UserJoinedOrganizationEvent
