Entity = require '../framework/Entity'

class Card extends Entity

  @table 'cards'

  @field   'title',        Entity.DataType.STRING
  @field   'body',         Entity.DataType.STRING
  @hasOne  'organization', 'Organization'
  @hasOne  'type',         'Type'
  @hasOne  'creator',      'User'
  @hasOne  'owner',        'User'
  @hasMany 'participants', 'User'

module.exports = Card
