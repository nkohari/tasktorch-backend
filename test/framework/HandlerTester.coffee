qs       = require 'querystring'
template = require 'url-template'

class HandlerTester

  constructor: (@server, @handler) ->
    {route} = @handler.options
    @verb = route.verb
    @template = template.parse(route.path)

  impersonate: (userid) ->
    @credentials = {user: {id: userid}}

  request: (args...) ->

    if args.length == 1
      options  = {}
      callback = args[0]
    else
      [options, callback] = args

    url = @template.expand(options)
    url += '?' + qs.stringify(options.query) if options.query?

    if options.credentials?
      if options.credentials is false
        credentials = undefined
      else
        credentials = options.credentials
    else
      credentials = @credentials

    @server.inject {
      method:      @verb
      url:         url
      credentials: credentials
      headers:     options.headers                 if options.headers?
      payload:     JSON.stringify(options.payload) if options.payload?
    }, callback

module.exports = HandlerTester
