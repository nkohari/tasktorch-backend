_      = require 'lodash'
Events = require '../events'
Entity = require '../framework/Entity'

class Organization extends Entity

  @table 'organizations'

  @field   'name',    Entity.DataType.STRING
  @hasMany 'teams',   'Team'
  @hasMany 'leaders', 'User'
  @hasMany 'members', 'User'

  addLeader: (user) ->
    @leaders = @leaders.concat [user]
    @announce new Events.OrganizationLeaderAddedEvent(this, user)

  removeLeader: (user) ->
    @leaders = _.filter @leaders, (u) -> u.equals(user)
    @announce new Events.OrganizationLeaderRemovedEvent(this, user)

  hasTeam: (team) ->
    _.any @teams, (t) -> t.equals(team)

  addTeam: (team) ->
    @teams = @teams.concat [team]
    team.organiation = this
    @announce new Events.TeamAddedEvent(this, team)

  removeTeam: (team) ->
    @teams = _.filter @teams, (t) -> t.equals(team)
    team.organization = undefined
    @announce new Events.TeamRemovedEvent(this, team)

  hasMember: (user) ->
    _.any @members, (u) -> u.equals(user)

  addMember: (user) ->
    @members = @members.concat [user]
    @announce new Events.UserJoinedOrganizationEvent(this, user)

  removeMember: (user) ->
    @members = _.filter @members, (u) -> u.equals(user)
    @announce new Events.UserLeftOrganizationEvent(this, user)

module.exports = Organization
