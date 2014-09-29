Event = require '../framework/Event'

class PasswordChangedEvent extends Event

  constructor: (@user) ->
    super()

module.exports = PasswordChangedEvent
