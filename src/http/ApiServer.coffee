fs   = require 'fs'
_    = require 'lodash'
Hapi = require 'hapi'

class ApiServer

  constructor: (@forge, @config, @log, @routeMap, @authenticator) ->
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
    for path, routes of @routeMap
      @register(path, routes)
    @server.start =>
      @log.info 'Server listening'

  register: (path, routes) ->
    for command, spec of routes
      if _.isString(spec)
        handler = spec
        options = undefined
      else
        handler = spec.handler
        options = _.omit(spec, 'handler')
      [type, func] = handler.split(/\./, 2)
      controller = @forge.get('controller', type)
      @log.debug "#{type}.#{func} - #{command} #{path}"
      @server.route
        method:  command
        path:    path
        handler: controller[func].bind(controller)
        config:  options

  onRequest: (request, next) ->
    command = request.headers['x-command']
    request.setMethod(command.toLowerCase()) if command?.length > 0
    request.baseUrl = "https://#{request.headers['host']}"
    next()

module.exports = ApiServer
