Document   = require 'data/framework/Document'
CardStatus = require 'data/enums/CardStatus'

class Card extends Document

  @table   'cards'
  @naming  {singular: 'card', plural: 'cards'}

  @field   'id'
  @field   'version'
  @field   'created'
  @field   'updated'
  @field   'status',    {default: CardStatus.NotStarted}
  @field   'title',     {default: null}
  @field   'summary',   {default: null}
  @field   'number'
  @field   'due',       {default: null}
  @field   'effort',    {default: null}
  @field   'moves',     {default: []}

  @hasOne  'creator',   {type: 'User'}
  @hasMany 'followers', {type: 'User',  default: []}
  @hasMany 'goals',     {type: 'Goal',  default: []}
  @hasMany 'stages',    {type: 'Stage', default: []}
  @hasMany 'files',     {type: 'File',  default: []}
  @hasOne  'kind',      {type: 'Kind'}
  @hasOne  'org',       {type: 'Org'}
  @hasOne  'user',      {type: 'User',  default: null}
  @hasOne  'team',      {type: 'Team',  default: null}
  @hasOne  'stack',     {type: 'Stack', default: null}

  @hasManyForeign 'actions',    {type: 'Action',    index: 'card'}
  @hasManyForeign 'checklists', {type: 'Checklist', index: 'card'}
  @hasManyForeign 'notes',      {type: 'Note',      index: 'card', order: {field: 'created'}}

module.exports = Card
