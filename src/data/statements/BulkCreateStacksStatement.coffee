Stack               = require 'data/documents/Stack'
BulkCreateStatement = require 'data/framework/statements/BulkCreateStatement'

class BulkCreateStacksStatement extends BulkCreateStatement

  constructor: (stacks) ->
    super(Stack, stacks)

module.exports = BulkCreateStacksStatement
