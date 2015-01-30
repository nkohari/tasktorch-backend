Note            = require 'data/documents/Note'
CreateStatement = require 'data/framework/statements/CreateStatement'

class CreateNoteStatement extends CreateStatement

  constructor: (data) ->
    super(Note, data)

module.exports = CreateNoteStatement
