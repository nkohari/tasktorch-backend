Entity = require '../framework/Entity'

class Stack extends Entity

  @table 'stacks'

  @field   'name',         Entity.DataType.STRING
  @field   'type',         Entity.DataType.STRING
  @hasOne  'organization', 'Organization'
  @hasOne  'owner',        'User'
  @hasOne  'team',         'Team'
  @hasMany 'cards',        'Card'

module.exports = Stack
