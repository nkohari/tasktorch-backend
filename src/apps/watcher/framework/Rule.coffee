class Rule

  supports: (activity, event) ->
    throw new Error("You must implement supports() on #{@constructor.name}")

  handle: (activity, event, callback) ->
    throw new Error("You must implement handle() on #{@constructor.name}")

module.exports = Rule
