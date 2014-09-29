_      = require 'lodash'
Entity = require '../framework/Entity'

class Team extends Entity

  @table 'teams'

  @field   'name',         Entity.DataType.STRING
  @hasOne  'organization', 'Organization'
  @hasMany 'leaders',      'User'
  @hasMany 'members',      'User'
  @hasMany 'stacks',       'Stack'

  hasMember: (user) ->
    _.any @members, (u) -> u.equals(user)

module.exports = Team
