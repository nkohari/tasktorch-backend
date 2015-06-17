_                  = require 'lodash'
Precondition       = require 'http/framework/Precondition'
MultiGetUsersQuery = require 'data/queries/users/MultiGetUsersQuery'

class ResolveMembersArgument extends Precondition

  assign: 'members'

  constructor: (@database) ->

  execute: (request, reply) ->

    userids = request.payload.members
    return reply [] unless userids?.length > 0

    query = new MultiGetUsersQuery(userids)
    @database.execute query, (err, result) =>
      return reply err if err?

      if result.users.length != userids.length
        missing = _.difference(userids, _.pluck(result.users, 'id'))
        return reply @error.badRequest("No such users with the ids #{missing.join(', ')}")

      reply(result.users)

module.exports = ResolveMembersArgument
