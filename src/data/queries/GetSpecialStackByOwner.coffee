r     = require 'rethinkdb'
Stack = require 'data/schemas/Stack'
Query = require 'data/framework/queries/Query'

class GetSpecialStackByOwner extends Query

  constructor: (userId, kind, options) ->
    super(Stack, options)
    @rql = r.table(Stack.table).getAll(userId, {index: 'owner'})
      .filter({kind})
      .limit(1)

  processResult: (result, callback) ->
    result.toArray (err, documents) =>
      return callback(err) if err?
      if documents.length == 0
        callback(null, null)
      else
        callback(null, documents[0])

module.exports = GetSpecialStackByOwner
