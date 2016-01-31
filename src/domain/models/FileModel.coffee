Model = require 'domain/framework/Model'

class FileModel extends Model

  constructor: (file) ->
    super(file)
    @name      = file.name
    @size      = file.size
    @type      = file.type
    @org       = file.org
    @url       = "/#{file.org}/files/#{file.id}/content"
    @thumbnail = "/#{file.org}/files/#{file.id}/thumbnail" if file.hasThumbnail

module.exports = FileModel
