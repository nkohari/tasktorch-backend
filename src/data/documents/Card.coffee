Document   = require 'data/framework/Document'
CardStatus = require 'data/enums/CardStatus'

class Card extends Document

  @table   'cards'
  @naming  {singular: 'card', plural: 'cards'}

  @field   'id'
  @field   'version'
  @field   'status',    {default: CardStatus.Normal}
  @field   'title',     {default: null}
  @field   'summary',   {default: null}
  @field   'actions'
  @field   'moves',     {default: []}

  @hasOne  'creator',   {type: 'User'}
  @hasMany 'followers', {type: 'User', default: []}
  @hasOne  'goal',      {type: 'Goal', default: null}
  @hasOne  'kind',      {type: 'Kind'}
  @hasOne  'org',       {type: 'Org'}
  @hasOne  'owner',     {type: 'User'}
  @hasOne  'stack',     {type: 'Stack'}

  @hasManyForeign 'notes', {type: 'Note', index: 'card', order: {field: 'time'}}

module.exports = Card
