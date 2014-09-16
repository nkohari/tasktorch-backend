Entity = require './framework/Entity'

class User extends Entity

  @table 'users'

  @field 'id', Entity.DataType.STRING
  @field 'email', Entity.DataType.STRING
  @field 'name', Entity.DataType.STRING
  @field 'property', Entity.DataType.STRING

module.exports = User
