r            = require 'rethinkdb'
Query        = require 'data/framework/queries/Query'
Organization = require 'data/schemas/Organization'
User         = require 'data/schemas/User'

class FindMembersOfOrganizationQuery extends Query

  constructor: (organizationId, phrase, options) ->
    super(User, options)
    expression = "(?i)^#{phrase}"
    @rql = r.table(User.table).getAll(
      r.args(r.table(Organization.table).get(organizationId)('members'))
    ).filter (user) ->
      r.or(user('username').match(expression), user('name').match(expression))

module.exports = FindMembersOfOrganizationQuery
