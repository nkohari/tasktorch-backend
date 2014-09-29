Entity = require '../framework/Entity'

class Team extends Entity

  @table 'teams'

  @field   'name',         Entity.DataType.STRING
  @hasOne  'organization', 'Organization'
  @hasMany 'leaders',      'User'
  @hasMany 'members',      'User'
  @hasMany 'stacks',       'Stack'

module.exports = Team
