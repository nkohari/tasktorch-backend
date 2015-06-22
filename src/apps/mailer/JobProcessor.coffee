# TODO: Split this into a facade/plugin system to support multiple kinds of jobs
class JobProcessor

  constructor: (@log, @renderer, @sender) ->

  process: (job, callback) ->

    @log.debug "Processing job #{job.id}"

    try
      email = @renderer.render(job)
    catch err
      return callback(err)

    @sender.send(email, callback)

module.exports = JobProcessor
