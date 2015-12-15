Stack               = require 'data/documents/Stack'
StackType           = require 'data/enums/StackType'
BulkCreateStatement = require 'data/statements/BulkCreateStatement'

class CreateDefaultUserStacksStatement extends BulkCreateStatement

  constructor: (userid, orgid) ->
    stacks = [
      new Stack { org: orgid, user: userid, type: StackType.Inbox  }
      new Stack { org: orgid, user: userid, type: StackType.Queue  }
    ]
    super(Stack, stacks)

module.exports = CreateDefaultUserStacksStatement
