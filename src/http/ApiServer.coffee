fs   = require 'fs'
_    = require 'lodash'
Hapi = require 'hapi'

class ApiServer

  constructor: (@forge, @config, @log, @authenticator) ->
    @server = new Hapi.Server @config.http.port,
      tls: @getTlsConfig()
    @server.ext 'onRequest', @onRequest.bind(this)
    @authenticator.init(@server)

  getTlsConfig: ->
    {key, cert} = @config.security.ssl
    return {
      key:  fs.readFileSync(key)
      cert: fs.readFileSync(cert)
    }

  start: ->
    handlers = @forge.getAll('handler')
    @register(handler) for handler in @forge.getAll('handler')
    @server.start =>
      @log.info 'Server listening'

  register: (handler) ->
    {route, demand, config} = handler.constructor.options
    config ?= {}

    if demand?
      demand = @forge.get('demand', demand)
      (config.pre ?= []).push demand.execute.bind(demand)

    @server.route
      method:  route.verb
      path:    route.path
      handler: handler.handle.bind(handler)
      config:  config

    @log.debug "Mounted #{handler.constructor.name} at #{route.verb} #{route.path}"

  onRequest: (request, next) ->
    request.baseUrl = "https://#{request.headers['host']}"
    next()

module.exports = ApiServer
