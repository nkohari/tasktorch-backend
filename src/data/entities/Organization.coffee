Entity = require '../framework/Entity'

class Organization extends Entity

  @table 'organizations'

  @field 'name', Entity.DataType.STRING

module.exports = Organization
