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
    handlers = @forge.getAll('handler')
    @register(handler) for handler in @forge.getAll('handler')
    @server.start =>
      @log.info '[http] Server listening'
      callback()

  register: (handler) ->

    {name, options} = handler.constructor
    {verb, path}    = options.route

    config = _.extend {
      json: {space: 2}
    }, options.config

    if options.pre?
      config.pre = _.map options.pre, (name) =>
        pre = @forge.get('precondition', name)
        return {
          method: pre.execute.bind(pre)
          assign: pre.assign ? undefined
        }

    @server.route {
      method:  verb
      path:    path
      handler: handler.handle.bind(handler)
      config:  config
    }

    @log.debug "[http] Mounted #{name} at #{verb} #{path}"

  setupAuthStrategy: ->
    {cookie} = @config.security

    options =
      cookie:       cookie.name
      domain:       cookie.domain
      ttl:          cookie.ttl
      password:     cookie.secret
      isSecure:     cookie.secure
      clearInvalid: true
      validateFunc: (state, callback) =>
        return callback(null, false) unless state?
        {sessionid, userid} = state
        @keymaster.validateSession(sessionid, userid, callback)

    @server.register require('hapi-auth-cookie'), (err) =>
      throw err if err?
      @server.auth.strategy('session', 'cookie', 'required', options)

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
