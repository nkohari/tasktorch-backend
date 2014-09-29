Entity = require '../framework/Entity'
Events = require '../events'

class User extends Entity

  @table 'users'

  @field 'username', Entity.DataType.STRING
  @field 'name',     Entity.DataType.STRING
  @field 'password', Entity.DataType.STRING

  setPassword: (password) ->
    @password = password
    @announce new Events.PasswordChangedEvent(this)

module.exports = User
