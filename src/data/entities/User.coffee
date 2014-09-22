Entity = require '../framework/Entity'

class User extends Entity

  @table 'users'

  @field 'username', Entity.DataType.STRING
  @field 'name', Entity.DataType.STRING
  @field 'password', Entity.DataType.STRING

module.exports = User
