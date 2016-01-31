_         = require 'lodash'
easyimage = require 'easyimage'
fs        = require 'fs'
os        = require 'os'
path      = require 'path'
uuid      = require 'common/util/uuid'

class Thumbnailer

  constructor: (@log) ->

  generate: (source, size, callback) ->

    dest = path.join(os.tmpdir(), uuid())
    @log.debug "Generating thumbnail: #{source} -> #{dest}"

    success = (image) =>
      callback(null, dest)

    failure = (err) =>
      @log.warn "Couldn't generate thumbnail: #{err}"
      callback()

    easyimage.thumbnail(src: source, dst: dest, width: size).then(success, failure)

module.exports = Thumbnailer
