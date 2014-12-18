Schema   = require 'data/Schema'
{HasOne} = require 'data/RelationType'

User = Schema.create 'User',

  table:    'users'
  singular: 'user'
  plural:   'users'

module.exports = User
