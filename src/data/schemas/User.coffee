Schema   = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

User = Schema.create 'User',

  table: 'users'

  relations:
    inbox: {type: HasOne,  schema: 'Stack'}
    stack: {type: HasOne,  schema: 'Stack'}

module.exports = User
