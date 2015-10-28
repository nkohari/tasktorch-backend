Activity                 = require 'apps/watcher/framework/Activity'
Rule                     = require 'apps/watcher/framework/Rule'
Model                    = require 'domain/framework/Model'
CreateIntercomCompanyJob = require 'domain/jobs/CreateIntercomCompanyJob'

class CreateIntercomCompanyWhenOrgCreated extends Rule

  constructor: (@jobQueue) ->

  offer: (activity, event) ->
    activity == Activity.Created and event.type == 'Org'

  handle: (activity, event, callback) ->
    org = event.document
    job = new CreateIntercomCompanyJob(Model.create(org), org.survey)
    @jobQueue.enqueue(job, callback)

module.exports = CreateIntercomCompanyWhenOrgCreated
