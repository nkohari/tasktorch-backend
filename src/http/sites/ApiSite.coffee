_ = require 'lodash'

class ApiSite

  vhost: 'api'

  constructor: (@forge, @log, @config, @keymaster) ->

  register: (server, options, callback) ->

    @setupAuthStrategy(server)
    @setupCookies(server)

    for handler in @forge.getAll('handler')
      @addHandler(server, handler)

    callback()

  addHandler: (server, handler) ->

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

    server.route {
      vhost:   "api.#{@config.http.domain}"
      method:  verb
      path:    path
      handler: handler.handle.bind(handler)
      config:  routeConfig
    }

    @log.debug "[http] Mounted #{name} at #{verb} #{path}"

  setupAuthStrategy: (server) ->

    options = _.extend {}, @config.security.session,
      clearInvalid: true
      validateFunc: (req, session, callback) =>
        return callback(null, false) unless session?
        {sessionid, userid} = session
        @keymaster.validateSession(sessionid, userid, callback)

    server.register require('hapi-auth-cookie'), (err) =>
      throw err if err?
      server.auth.strategy('session', 'cookie', 'required', options)

  setupCookies: (server) ->

    for name, cookieConfig of @config.security.cookies
      server.state(name, cookieConfig)

module.exports = ApiSite
