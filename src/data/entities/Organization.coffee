User   = require './User'
Entity = require '../framework/Entity'

class Organization extends Entity

  @table 'organizations'

  @field 'name', Entity.DataType.STRING
  @hasMany 'users', User

module.exports = Organization
