r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Card  = require 'data/documents/Card'

class GetAllCardsByFollowerQuery extends Query

  constructor: (orgid, userid, options) ->
    super(Card, options)

    @rql = r.table(@schema.table)
      .getAll(userid, {index: 'followers'})
      .filter(r.row('org').eq(orgid))
      .default([]).coerceTo('array')

module.exports = GetAllCardsByFollowerQuery
