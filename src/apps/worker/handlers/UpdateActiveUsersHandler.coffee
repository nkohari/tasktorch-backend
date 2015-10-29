_                             = require 'lodash'
JobHandler                    = require 'apps/worker/framework/JobHandler'
Org                           = require 'data/documents/Org'
GetAllActiveMembersByOrgQuery = require 'data/queries/users/GetAllActiveMembersByOrgQuery'
UpdateActiveMembersJob        = require 'domain/jobs/UpdateActiveMembersJob'
ChangeOrgActiveMembersCommand = require 'domain/commands/orgs/ChangeOrgActiveMembersCommand'

class UpdateActiveMembersHandler extends JobHandler

  handles: UpdateActiveMembersJob

  constructor: (@log, @database, @processor) ->
    super()

  handle: (job, callback) ->

    {orgid} = job

    @log.debug "Counting active members for org #{orgid}"
    query = new GetAllActiveMembersByOrgQuery(orgid)
    @database.execute query, (err, result) =>

      if err?
        @log.error("Error getting active members for org #{orgid}: #{err.stack ? err}")
        return callback()

      ids     = _.map result.users, (u) -> u.id
      command = new ChangeOrgActiveMembersCommand(orgid, ids)
      
      @log.debug "Org #{orgid} has #{ids.length} active members"
      @processor.execute(command, callback)

module.exports = UpdateActiveMembersHandler
