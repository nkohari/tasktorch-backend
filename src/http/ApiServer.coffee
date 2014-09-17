fs   = require 'fs'
_    = require 'lodash'
Hapi = require 'hapi'

class ApiServer

  constructor: (@forge, @config, @log, @routeMap) ->
    {key, cert} = @config.security.ssl
    tls =
      key:  fs.readFileSync(key)
      cert: fs.readFileSync(cert)
    @server = new Hapi.Server(@config.http.port, {tls})
    @server.ext 'onRequest', (request, next) =>
      command = request.headers['x-command']
      request.setMethod(command.toLowerCase()) if command?.length > 0
      next()

  start: ->
    for path, routes of @routeMap
      @register(path, routes)
    @server.start =>
      @log.info 'Server listening'

  register: (path, routes) ->
    _.each routes, (handler, command) =>
      [type, func] = handler.split(/\./, 2)      
      resource = @forge.get('resource', type)
      @log.debug "#{type}.#{func} - #{command} #{path}"
      @server.route
        method:  command
        path:    path
        handler: resource[func].bind(resource)

module.exports = ApiServer
