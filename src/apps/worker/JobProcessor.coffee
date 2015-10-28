class JobProcessor

  constructor: (@log, @forge) ->
    @handlers = {}
    for handler in @forge.getAll('handler')
      type = handler.handles.name.replace(/Job$/, '')
      @addHandler(type, handler)

  addHandler: (type, handler) ->
    @log.info "Registered #{handler.constructor.name} as handler for #{type} jobs"
    @handlers[type] = handler

  process: (job, callback) ->
    @log.debug "Processing #{job.type} job #{job.id}"
    handler = @handlers[job.type]
    if handler?
      handler.handle(job, callback)
    else
      callback(null, new Error("Don't know how to handle job with type #{job.type}"))

module.exports = JobProcessor
