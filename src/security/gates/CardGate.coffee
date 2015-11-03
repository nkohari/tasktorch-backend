_                                 = require 'lodash'
Gate                              = require 'security/framework/Gate'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'

class CardGate extends Gate

  guards: 'Card'

  constructor: (@database) ->

  getAccessList: (card, callback) ->
    query = new GetAllActiveMembershipsByOrgQuery(card.org)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback null, _.pluck(result.memberships, 'user')

module.exports = CardGate
