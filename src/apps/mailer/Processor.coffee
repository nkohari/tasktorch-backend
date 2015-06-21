class Processor

  constructor: (@log, @renderer, @sender) ->

  process: (request, callback) ->

    try
      email = @renderer.render(request)
    catch err
      return callback(err)

    @log.inspect(email)
    @sender.send(email, callback)

module.exports = Processor
