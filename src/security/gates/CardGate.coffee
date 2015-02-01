_           = require 'lodash'
Gate        = require 'security/framework/Gate'
GetOrgQuery = require 'data/queries/orgs/GetOrgQuery'

class CardGate extends Gate

  guards: 'Card'

  constructor: (@database) ->

  getAccessList: (card, callback) ->
    query = new GetOrgQuery(card.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.clone(result.org.members)

module.exports = CardGate
