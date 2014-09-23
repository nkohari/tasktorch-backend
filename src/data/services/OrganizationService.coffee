UserJoinedOrganizationEvent = require 'events/organizations/UserJoinedOrganizationEvent'
UserLeftOrganizationEvent   = require 'events/organizations/UserLeftOrganizationEvent'
Organization                = require '../entities/Organization'
Service                     = require '../framework/Service'

class OrganizationService extends Service

  @type Organization

  addMember: (organization, user, callback) ->
    organization.users.add(user)
    event = new UserJoinedOrganizationEvent(organization, user)
    @update organization, (err) =>
      return callback(err) if err?
      @publish(event)
      callback()

  removeMember: (organization, user, callback) ->
    organization.users.remove(user)
    event = new UserLeftOrganizationEvent(organization, user)
    @update organization, (err) =>
      return callback(err) if err?
      @publish(event)
      callback()

module.exports = OrganizationService
