Schema   = require 'data/Schema'
{HasOne} = require 'data/RelationType'

Note = Schema.create 'Note',

  table:    'notes'
  singular: 'note'
  plural:   'notes'

  relations:
    org:  {type: HasOne, schema: 'Org'}
    card: {type: HasOne, schema: 'Card'}
    user: {type: HasOne, schema: 'User'}

module.exports = Note
