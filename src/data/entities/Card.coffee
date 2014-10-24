Entity                = require '../framework/Entity'
CardBodyChangedEvent  = require '../events/cards/CardBodyChangedEvent'
CardTitleChangedEvent = require '../events/cards/CardTitleChangedEvent'

class Card extends Entity

  @table 'cards'

  @field   'title',        Entity.DataType.STRING
  @field   'body',         Entity.DataType.STRING
  @hasOne  'organization', 'Organization'
  @hasOne  'type',         'Type'
  @hasOne  'creator',      'User'
  @hasOne  'owner',        'User'
  @hasMany 'participants', 'User'
  @hasOne  'stack',        'Stack'

  setBody: (value, metadata) ->
    event = new CardBodyChangedEvent(this, value, metadata)
    @body = value
    @incrementVersion()
    @announce(event)

  setTitle: (value, metadata) ->
    event = new CardTitleChangedEvent(this, value, metadata)
    @title = value
    @incrementVersion()
    @announce(event)

module.exports = Card
