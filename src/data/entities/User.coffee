Entity = require '../framework/Entity'
PasswordChangedEvent = require 'events/users/PasswordChangedEvent'

class User extends Entity

  @table 'users'

  @field 'username', Entity.DataType.STRING
  @field 'name',     Entity.DataType.STRING
  @field 'password', Entity.DataType.STRING

  setPassword: (password) ->
    @password = password
    @announce new PasswordChangedEvent(this)

module.exports = User
