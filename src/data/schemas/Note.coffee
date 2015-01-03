Schema   = require 'data/Schema'
{HasOne} = require 'data/RelationType'

Note = Schema.create 'Note',

  table:    'notes'
  singular: 'note'
  plural:   'notes'

  relations:
    organization: {type: 'HasOne', schema: 'Organization'}
    card:         {type: HasOne, schema: 'Card'}
    user:         {type: HasOne, schema: 'User'}

module.exports = Note
