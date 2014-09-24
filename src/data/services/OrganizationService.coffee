UserJoinedOrganizationEvent = require 'events/organizations/UserJoinedOrganizationEvent'
UserLeftOrganizationEvent   = require 'events/organizations/UserLeftOrganizationEvent'
Organization                = require '../entities/Organization'
Service                     = require '../framework/Service'

class OrganizationService extends Service

  @type Organization

  addMember: (organization, user, callback) ->
    organization.members.add(user)
    event = new UserJoinedOrganizationEvent(organization, user)
    @database.update organization, (err) =>
      return callback(err) if err?
      @eventBus.publish(event)
      callback()

  removeMember: (organization, user, callback) ->
    organization.members.remove(user)
    event = new UserLeftOrganizationEvent(organization, user)
    @database.update organization, (err) =>
      return callback(err) if err?
      @eventBus.publish(event)
      callback()

module.exports = OrganizationService
