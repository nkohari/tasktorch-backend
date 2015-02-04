Stack               = require 'data/documents/Stack'
StackType           = require 'data/enums/StackType'
BulkCreateStatement = require 'data/framework/statements/BulkCreateStatement'

class CreateDefaultUserStacksStatement extends BulkCreateStatement

  constructor: (userid, orgid) ->
    stacks = [
      new Stack { org: orgid, user: userid, type: StackType.Inbox  }
      new Stack { org: orgid, user: userid, type: StackType.Queue  }
      new Stack { org: orgid, user: userid, type: StackType.Drafts }
    ]
    super(Stack, stacks)

module.exports = CreateDefaultUserStacksStatement
