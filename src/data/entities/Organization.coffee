Events = require 'events'
Entity = require '../framework/Entity'

class Organization extends Entity

  @table 'organizations'

  @field   'name',    Entity.DataType.STRING
  @hasMany 'teams',   'Team'
  @hasMany 'leaders', 'User'
  @hasMany 'members', 'User'

  addLeader: (user) ->
    @leaders.add(user)
    @announce new Events.OrganizationLeaderAddedEvent(this, user)

  removeLeader: (user) ->
    @leaders.remove(user)
    @announce new Events.OrganizationLeaderRemovedEvent(this, user)

  addTeam: (team) ->
    @teams.add(team, team.id)
    team.organiation = this
    @announce new Events.TeamAddedEvent(this, team)

  removeTeam: (team) ->
    @teams.remove(team, team.id)
    team.organization = undefined
    @announce new Events.TeamRemovedEvent(this, team)

  addMember: (user) ->
    @members.add(user)
    @announce new Events.UserJoinedOrganizationEvent(this, user)

  removeMember: (user) ->
    @members.remove(user)
    @announce new Events.UserLeftOrganizationEvent(this, user)

module.exports = Organization
