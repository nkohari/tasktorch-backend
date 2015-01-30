Model = require 'domain/framework/Model'

class NoteModel extends Model

  constructor: (note) ->
    super(note)
    @type    = note.type
    @time    = note.time
    @org     = note.org
    @card    = note.card
    @user    = note.user
    @content = note.content

module.exports = NoteModel
