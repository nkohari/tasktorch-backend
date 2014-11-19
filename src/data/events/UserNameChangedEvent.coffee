Event = require 'data/framework/Event'
User  = require 'data/schemas/User'

class UserNameChangedEvent extends Event

  constructor: (user) ->
    super()
    @document = {type: User.name, id: user.id, version: user.version}
    @meta     = {user: user.id}
    @payload  = {name: user.name}

module.exports = UserNameChangedEvent
