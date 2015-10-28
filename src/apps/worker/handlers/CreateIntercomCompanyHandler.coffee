JobHandler               = require 'apps/worker/framework/JobHandler'
GetInviteQuery           = require 'data/queries/invites/GetInviteQuery'
CreateIntercomCompanyJob = require 'domain/jobs/CreateIntercomCompanyJob'

class CreateIntercomCompanyHandler extends JobHandler

  handles: CreateIntercomCompanyJob

  constructor: (@log, intercom) ->
    super()
    @intercom = intercom.createClient()

  handle: (job, callback) ->

    {org, survey} = job

    params =
      name:              org.name
      company_id:        org.id
      remote_created_at: org.created
      custom_attributes:
        'Expected Seats': @formatSize(survey.size)
        'Company Size':   @formatSize(survey.tsp)
        'Creator Role':   @formatRole(survey.role)
        'Expected Kinds': survey.kinds.join(', ')

    @log.debug "[intercom] Sending org #{org.id} (#{org.name}) to Intercom"
    @intercom.createCompany(params, callback)

  formatSize: (size) ->
    switch size
      when 'xs' then 'Fewer than 10'
      when 'sm' then '10-100'
      when 'md' then '101-500'
      when 'lg' then 'More than 500'
      else 'Unknown'

  formatRole: (role) ->
    switch role
      when 'employee' then 'Individual contributor'
      when 'manager'  then 'Manager or team leader'
      when 'director' then 'Director or vice president'
      when 'exec'     then 'Executive leader'
      else 'Unknown'

module.exports = CreateIntercomCompanyHandler
