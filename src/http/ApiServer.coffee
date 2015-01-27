fs     = require 'fs'
_      = require 'lodash'
Hapi   = require 'hapi'
etag   = require 'common/util/etag'
Header = require './framework/Header'

class ApiServer

  constructor: (@forge, @config, @log, @authenticator) ->
    @server = new Hapi.Server @config.http.port,
      tls: @getTlsConfig()
      json: {space: 2}
    @server.ext 'onRequest',     @onRequest.bind(this)
    @server.on  'internalError', @onError.bind(this)
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

    options = handler.constructor.options
    route   = options.route
    config  = options.config ? {}

    if options.prereqs?
      config.pre = _.map options.prereqs, (component, assign) =>
        prereq = @forge.get('prereq', component)
        {method: prereq.execute.bind(prereq), assign: assign}

    # TODO: Move demands into prereqs?
    if options.demand?
      demands = _.flatten [options.demand]
      config.pre ?= []
      config.pre = config.pre.concat _.map demands, (name) =>
        demand = @forge.get('demand', name)
        demand.execute.bind(demand)

    @server.route
      method:  route.verb
      path:    route.path
      handler: handler.handle.bind(handler)
      config:  config

    @log.debug "Mounted #{handler.constructor.name} at #{route.verb} #{route.path}"

  onRequest: (request, next) ->
    
    request.baseUrl = "http://#{request.headers[Header.Host]}/api"
    request.scope   = {}
    request.socket  = request.headers[Header.Socket]

    ifMatch = request.headers[Header.IfMatch]
    if ifMatch?.length > 0
      try
        request.expectedVersion = Number(etag.decode(ifMatch))
      catch err
        # Ignore if malformed

    next()

  onError: (request, err) ->
    @log.error "Request failed with error: #{err}"

module.exports = ApiServer
