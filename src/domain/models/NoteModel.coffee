Model = require 'domain/Model'

class NoteModel extends Model

  constructor: (note) ->
    super(note)
    @type         = note.type
    @time         = note.time
    @organization = note.organization
    @card         = note.card
    @user         = note.user
    @content      = note.content

module.exports = NoteModel