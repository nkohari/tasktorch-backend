Intercom       = require 'intercom.io'
Activity       = require 'apps/watcher/framework/Activity'
Rule           = require 'apps/watcher/framework/Rule'
GetInviteQuery = require 'data/queries/invites/GetInviteQuery'

class SendOrgToIntercom extends Rule

  constructor: (@log, intercom) ->
    @intercom = intercom.createClient()

  offer: (activity, event) ->
    activity == Activity.Created and event.type == 'Org'

  handle: (activity, event, callback) ->

    org = event.document

    params =
      name:              org.name
      company_id:        org.id
      remote_created_at: org.created
      custom_attributes:
        'Expected Seats': @formatSize(org.survey.size)
        'Company Size':   @formatSize(org.survey.tsp)
        'Creator Role':   @formatRole(org.survey.role)
        'Expected Kinds': org.survey.kinds.join(', ')

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

module.exports = SendOrgToIntercom
