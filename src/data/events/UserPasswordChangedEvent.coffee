Event = require 'data/framework/Event'
User  = require 'data/schemas/User'

class UserPasswordChangedEvent extends Event

  constructor: (user) ->
    super()
    @document = {type: User.name, id: user.id, version: user.version}
    @meta     = {user: user.id}
    @payload  = {}

module.exports = UserPasswordChangedEvent
