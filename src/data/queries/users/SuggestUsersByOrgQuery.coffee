r                = require 'rethinkdb'
Query            = require 'data/framework/queries/Query'
Membership       = require 'data/documents/Membership'
User             = require 'data/documents/User'
MembershipStatus = require 'data/enums/MembershipStatus'

class SuggestUsersByOrgQuery extends Query

  constructor: (orgid, phrase, options) ->
    super(User, options)

    expression = "(?i)#{phrase}"
    userids = r.table(Membership.getSchema().table)
      .getAll(orgid, {index: 'org'})
      .filter({status: MembershipStatus.Normal})('user')

    @rql = r.table(@schema.table).getAll(r.args(userids))
    .filter (user) -> r.or(user('username').match(expression), user('name').match(expression))
    .coerceTo('array')

module.exports = SuggestUsersByOrgQuery
