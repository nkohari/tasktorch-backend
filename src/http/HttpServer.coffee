_    = require 'lodash'
Hapi = require 'hapi'

class HttpServer

  constructor: (@forge, @config, @log) ->
    @server = new Hapi.Server()
    @server.on 'request-error', @onError.bind(this)
    @server.connection {
      port: @config.http.port
      tls:
        key: @config.http.tls.key
        cert: @config.http.tls.cert
      routes:
        cors:
          credentials: true
    }

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

  onError: (request, err) ->
    @log.error "Request failed with error: #{err}"

module.exports = HttpServer
