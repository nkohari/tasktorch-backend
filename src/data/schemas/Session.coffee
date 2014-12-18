Schema   = require 'data/Schema'
{HasOne} = require 'data/RelationType'

Session = Schema.create 'Session',

  table:    'sessions'
  singular: 'session'
  plural:   'sessions'

  relations:
    user: {type: HasOne,  schema: 'User'}

module.exports = Session
