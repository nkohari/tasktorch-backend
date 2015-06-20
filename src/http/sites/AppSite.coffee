fs   = require 'fs'
path = require 'path'

class AppSite

  constructor: (@log, @config) ->

  register: (server, options, callback) ->

    if @config.env == 'dev'
      @log.info "[http] Not serving client shim in development mode"
      return callback()

    filename = path.resolve(process.cwd(), 'assets/index.html')
    content  = fs.readFileSync(filename, 'utf8').replace(/%VERSION%/g, @config.client.version)

    @log.info "[http] Serving client version #{@config.client.version}"

    server.route {
      vhost:  "app.#{@config.http.domain}"
      method: '*'
      path:   '/{path*}'
      config: {auth: false}
      handler: (req, reply) -> reply(content)
    }
      
    callback()

module.exports = AppSite
