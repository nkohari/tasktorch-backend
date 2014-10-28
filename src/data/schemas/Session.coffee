Schema = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

Session = Schema.create 'Session',

  table: 'sessions'

  relations:
    user: {type: HasOne,  schema: 'User'}

module.exports = Session
