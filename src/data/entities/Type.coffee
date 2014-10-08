Entity = require '../framework/Entity'

class Type extends Entity

  @table 'types'

  @field  'name',         undefined
  @field  'steps',        undefined
  @hasOne 'organization', 'Organization'

module.exports = Type
