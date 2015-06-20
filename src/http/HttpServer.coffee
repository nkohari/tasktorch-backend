_    = require 'lodash'
Hapi = require 'hapi'

class HttpServer

  constructor: (@forge, @config, @log) ->
    @server = new Hapi.Server()
    @server.connection {
      port: @config.http.port
      tls: @config.http.tls
      routes:
        cors:
          credentials: true
    }
    @server.ext 'onRequest',     @onRequest.bind(this)
    @server.on  'request-error', @onError.bind(this)

  start: (callback = (->)) ->
    @log.info '[http] Starting server'

    plugins = _.map @forge.getAll('site'), (site) =>
      @log.info "[http] Registering #{site.constructor.name}"
      register = _.bind(site.register, site)
      register.attributes = {name: site.constructor.name}
      return {register}

    @server.register plugins, (err) =>
      if err?
        @log.error "[http] Error registering sites: #{err}"
        return callback(err)
      @server.start =>
        @log.info '[http] Server listening'
        callback()

  onRequest: (request, reply) ->
    if request.server.info.protocol isnt 'https'
      return reply.redirect("https://#{request.headers.host}#{request.path}")
    reply.continue()

  onError: (request, err) ->
    @log.error "Request failed with error: #{err}"

module.exports = HttpServer
