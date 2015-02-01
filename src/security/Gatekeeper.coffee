_ = require 'lodash'

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

module.exports = Gatekeeper
