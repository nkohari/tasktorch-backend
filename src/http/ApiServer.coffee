fs     = require 'fs'
_      = require 'lodash'
Hapi   = require 'hapi'
etag   = require 'common/util/etag'
Header = require './framework/Header'

class ApiServer

  constructor: (@forge, @config, @log, @keymaster) ->
    @server = new Hapi.Server()
    @server.connection(@config.http)
    @server.ext 'onRequest',     @onRequest.bind(this)
    @server.on  'request-error', @onError.bind(this)

  start: (callback = (->)) ->
    @log.info '[http] Starting server'
    @setupAuthStrategy()
    @setupCookies()
    handlers = @forge.getAll('handler')
    @register(handler) for handler in @forge.getAll('handler')
    @server.start =>
      @log.info '[http] Server listening'
      callback()

  register: (handler) ->

    {name, options} = handler.constructor
    {verb, path}    = options.route

    routeConfig = _.extend {
      json: {space: 2}
    }, options.config

    if options.preconditions?
      routeConfig.pre = _.map options.preconditions, (name) =>
        precond = @forge.get('precondition', name)
        return {
          method: precond.execute.bind(precond)
          assign: precond.assign ? undefined
        }

    @server.route {
      method:  verb
      path:    path
      handler: handler.handle.bind(handler)
      config:  routeConfig
    }

    @log.debug "[http] Mounted #{name} at #{verb} #{path}"

  setupAuthStrategy: ->

    options = _.extend {}, @config.security.session,
      clearInvalid: true
      validateFunc: (req, session, callback) =>
        return callback(null, false) unless session?
        {sessionid, userid} = session
        @keymaster.validateSession(sessionid, userid, callback)

    @server.register require('hapi-auth-cookie'), (err) =>
      throw err if err?
      @server.auth.strategy('session', 'cookie', 'required', options)

  setupCookies: ->
    for name, cookieConfig of @config.security.cookies
      @server.state(name, cookieConfig)

  onRequest: (request, reply) ->
    
    request.baseUrl = "http://#{request.headers[Header.Host]}/api"

    ifMatch = request.headers[Header.IfMatch]
    if ifMatch?.length > 0
      try
        request.expectedVersion = Number(etag.decode(ifMatch))
      catch err
        # Ignore if malformed

    reply.continue()

  onError: (request, err) ->
    @log.error "Request failed with error: #{err}"

module.exports = ApiServer
