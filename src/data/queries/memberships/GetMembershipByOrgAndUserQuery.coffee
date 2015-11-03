r          = require 'rethinkdb'
Membership = require 'data/documents/Membership'
Query      = require 'data/framework/queries/Query'

class GetMembershipByOrgAndUserQuery extends Query

  constructor: (orgid, userid, options) ->
    super(Membership, options)
    @rql = r.table(@schema.table).getAll(userid, {index: 'user'}).filter({org: orgid}).default([]).coerceTo('array')

  preprocessResult: (result, callback) ->
    result.toArray (err, items) =>
      return callback(err) if err?
      if items.length == 0
        callback(null, null)
      else
        callback(null, items[0])

module.exports = GetMembershipByOrgAndUserQuery
