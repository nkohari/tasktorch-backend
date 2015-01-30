r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Org   = require 'data/documents/Org'
User  = require 'data/documents/User'

class SuggestMembersByOrgQuery extends Query

  constructor: (orgid, phrase, options) ->
    super(User, options)
    expression = "(?i)^#{phrase}"
    @rql = r.table(@schema.table).getAll(
      r.args(r.table(Org.getSchema().table).get(orgid)('members'))
    )
    .filter (user) -> r.or(user('username').match(expression), user('name').match(expression))
    .coerceTo('array')

module.exports = SuggestMembersByOrgQuery
