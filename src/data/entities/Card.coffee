Entity = require '../framework/Entity'

class Card extends Entity

  @table 'cards'

  @field   'name',         Entity.DataType.STRING
  @hasOne  'organization', 'Organization'
  @hasOne  'creator',      'User'
  @hasOne  'owner',        'User'
  @hasMany 'participants', 'User'

module.exports = Card