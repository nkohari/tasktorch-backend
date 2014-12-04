Schema   = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

User = Schema.create 'User',

  table: 'users'

module.exports = User
