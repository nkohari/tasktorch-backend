Session         = require 'data/documents/Session'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class UpdateSessionStatement extends UpdateStatement

  constructor: (id, diff) ->
    super(Session, id, diff)

module.exports = UpdateSessionStatement
