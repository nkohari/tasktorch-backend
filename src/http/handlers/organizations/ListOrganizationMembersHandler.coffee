_               = require 'lodash'
{User}          = require 'data/entities'
{MultiGetQuery} = require 'data/queries'
UserModel       = require '../../models/UserModel'
Handler         = require '../../framework/Handler'

class ListOrganizationMembersHandler extends Handler

  @route 'get /api/{organizationId}/members'
  @demand 'requester is organization member'
  
  constructor: (@database) ->

  handle: (request, reply) ->

    {organization} = request.scope

    ids    = organization.members.map (m) -> m.id
    expand = request.query.expand?.split(',')
    query  = new MultiGetQuery(User, ids, {expand})

    @database.execute query, (err, users) =>
      return reply err if err?
      reply _.map users, (user) -> new UserModel(user, request)

module.exports = ListOrganizationMembersHandler
