Entity = require './framework/Entity'

class Organization extends Entity

  @table 'organizations'

  @field 'id', Entity.DataType.UUID
  @field 'name', Entity.DataType.STRING

module.exports = Organization
