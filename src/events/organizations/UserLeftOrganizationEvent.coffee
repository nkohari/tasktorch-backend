Event = require '../framework/Event'

class UserLeftOrganizationEvent extends Event

  constructor: (@organization, @user) ->
    super()

module.exports = UserLeftOrganizationEvent
