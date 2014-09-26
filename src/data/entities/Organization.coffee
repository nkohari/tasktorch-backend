User = require './User'
Entity = require '../framework/Entity'
UserJoinedOrganizationEvent = require 'events/organizations/UserJoinedOrganizationEvent'
UserLeftOrganizationEvent = require 'events/organizations/UserLeftOrganizationEvent'

class Organization extends Entity

  @table 'organizations'

  @field   'name',    Entity.DataType.STRING
  @hasMany 'leaders', User
  @hasMany 'members', User

  addMember: (user) ->
    organization.members.add(user)
    @announce new UserJoinedOrganizationEvent(this, user)

  removeMember: (user) ->
    organization.members.remove(user)
    @announce new UserLeftOrganizationEvent(this, user)

module.exports = Organization
