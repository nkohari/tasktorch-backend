_        = require 'lodash'
UserFlag = require 'data/enums/UserFlag'

class Gatekeeper

  constructor: (@forge) ->
    @gates = _.object _.map @forge.getAll('gate'), (gate) -> [gate.guards, gate]

  canUserAccess: (document, user, callback) ->
    @getAccessList document, (err, userids) =>
      return callback(err) if err?
      return callback null, _.contains(userids, user.id)

  getAccessList: (document, callback) ->
    gate = @gates[document.constructor.name]
    unless gate?
      return callback new Error("Don't know how to resolve access for a document of type #{document.constructor.name}")
    gate.getAccessList(document, callback)

  canUserSetFlag: (granter, grantee, flag, value, callback) ->
    # TODO: Right now, this only allows granting of the WalkthroughComplete flag
    # to yourself. This should be expanded if flags continue to be useful.
    allowed = (granter.id == grantee.id) and (flag == UserFlag.HasCompletedWalkthrough) and (value == true)
    callback(null, allowed)

module.exports = Gatekeeper
